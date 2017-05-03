String::capitalize = ->
  @replace /^./, (letter) ->
    letter.toUpperCase()

ko.bindingHandlers.time =
  update: (element, valueAccessor, allBindings, viewModel, bindingContext) ->
    $(element).attr 'datetime', ko.unwrap(valueAccessor())
    $(element).timeago()

processData = (data) ->
  data.portals = ({dimension, portals} for dimension, portals of data.portals)
  data

serverData = {}
eventSources = {}

window.API_URL = '//api.dofusportal.net'
previous_request = null
viewModel =
  servers: ['Echo', 'OtoMustam', 'Test']
  loadData: (server) ->
    (callback) ->
      $('#spinner').show()
      previous_request?.abort()
      previous_request = $.getJSON "#{window.API_URL}/#{server}", (data) ->
        if EventSource? and server not of eventSources
          eventSource = new EventSource("#{window.API_URL}/watch/#{server}")
          eventSources[server] = eventSource
          eventSource.onmessage = (event) ->
            if server of serverData
              updateData = JSON.parse event.data
              processData updateData
              serverData[server].data(updateData)

        processData data

        if server of serverData
          result = serverData[server]
          result.data(data)
        else
          result = {data: ko.observable data}
          serverData[server] = result
          callback result
      .always -> $('#spinner').fadeOut()

window.viewModel = viewModel
window.serverData = serverData
window.eventSources = eventSources

$ ->
  $('<div id="spinner"><progress indeterminate></progress></div>').appendTo('body').hide()
  pager.extendWithPage viewModel
  ko.applyBindings viewModel, document.documentElement
  pager.onBindingError.add (event) ->
    console.log event
  pager.start()

ko.bindingHandlers.debug =
  init: (element, valueAccessor) ->
    console.log 'Knockoutbinding:'
    console.log element
    console.log ko.toJS(valueAccessor())
