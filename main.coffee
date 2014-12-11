String::capitalize = ->
  @replace /^./, (letter) ->
    letter.toUpperCase()

ko.bindingHandlers.time =
  update: (element, valueAccessor, allBindings, viewModel, bindingContext) ->
    $(element).attr 'datetime', ko.unwrap(valueAccessor())
    $(element).timeago()

viewModel =
  servers: ['Rushu', 'Rosal', 'Shika']
  loadData: (server) ->
    (callback) ->
      $.getJSON "//api.dofusportal.net/#{server}", (data) ->
        data.portals = ({dimension, portals} for dimension, portals of data.portals)
        callback data
window.viewModel = viewModel
$ ->
  pager.extendWithPage viewModel
  ko.applyBindings viewModel, document.documentElement
  pager.start()

