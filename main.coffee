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
viewModel =
  servers: ['Rushu', 'Rosal', 'Shika']
  loadData: (server) ->
    (callback) ->
      $.getJSON "//api.dofusportal.net/#{server}", (data) ->
        processData data
        if server of serverData
          result = serverData[server]
          result.data(data)
        else
          result = {data: ko.observable data}
          serverData[server] = result
          callback result

viewModel.servers.forEach (server) ->
  eventsource = new EventSource("//api.dofusportal.net/watch/#{server}")
  eventsource.onmessage = (event) ->
    if server of serverData
      data = JSON.parse event.data
      processData data
      serverData[server].data(data)

window.viewModel = viewModel
window.serverData = serverData
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
