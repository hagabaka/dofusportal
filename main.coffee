String::capitalize = ->
  @replace /^./, (letter) ->
    letter.toUpperCase()
viewModel =
  servers: ['Rushu']
  loadData: (server) ->
    (callback) ->
      $.getJSON "//api.dofusportal.tk/#{server}", (data) ->
        data.portals = ({dimension, portals} for dimension, portals of data.portals)
        callback data
window.viewModel = viewModel
$ ->
  pager.extendWithPage viewModel
  ko.applyBindings viewModel
  pager.start()

