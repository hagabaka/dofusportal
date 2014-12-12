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
viewModel =
  servers: ['Rushu', 'Rosal', 'Shika']
  loadData: (server) ->
    (callback) ->
      $.getJSON "//api.dofusportal.net/#{server}", (data) ->
        unless server of eventSources
          eventSource = new EventSource("//api.dofusportal.net/watch/#{server}")
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

window.viewModel = viewModel
window.serverData = serverData
window.eventSources = eventSources

$ ->
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
