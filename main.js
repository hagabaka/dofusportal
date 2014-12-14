// Generated by CoffeeScript 1.7.1
(function() {
  var eventSources, processData, serverData, viewModel;

  String.prototype.capitalize = function() {
    return this.replace(/^./, function(letter) {
      return letter.toUpperCase();
    });
  };

  ko.bindingHandlers.time = {
    update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
      $(element).attr('datetime', ko.unwrap(valueAccessor()));
      return $(element).timeago();
    }
  };

  processData = function(data) {
    var dimension, portals;
    data.portals = (function() {
      var _ref, _results;
      _ref = data.portals;
      _results = [];
      for (dimension in _ref) {
        portals = _ref[dimension];
        _results.push({
          dimension: dimension,
          portals: portals
        });
      }
      return _results;
    })();
    return data;
  };

  serverData = {};

  eventSources = {};

  viewModel = {
    servers: ['Rushu', 'Rosal', 'Shika'],
    loadData: function(server) {
      return function(callback) {
        $('#spinner').show();
        return $.getJSON("//api.dofusportal.net/" + server, function(data) {
          var eventSource, result;
          if ((typeof EventSource !== "undefined" && EventSource !== null) && !(server in eventSources)) {
            eventSource = new EventSource("//api.dofusportal.net/watch/" + server);
            eventSources[server] = eventSource;
            eventSource.onmessage = function(event) {
              var updateData;
              if (server in serverData) {
                updateData = JSON.parse(event.data);
                processData(updateData);
                return serverData[server].data(updateData);
              }
            };
          }
          processData(data);
          if (server in serverData) {
            result = serverData[server];
            return result.data(data);
          } else {
            result = {
              data: ko.observable(data)
            };
            serverData[server] = result;
            return callback(result);
          }
        }).always(function() {
          return $('#spinner').hide();
        });
      };
    }
  };

  window.viewModel = viewModel;

  window.serverData = serverData;

  window.eventSources = eventSources;

  $(function() {
    $('<div id="spinner"><progress indeterminate></progress></div>').appendTo('body').hide();
    pager.extendWithPage(viewModel);
    ko.applyBindings(viewModel, document.documentElement);
    pager.onBindingError.add(function(event) {
      return console.log(event);
    });
    return pager.start();
  });

  ko.bindingHandlers.debug = {
    init: function(element, valueAccessor) {
      console.log('Knockoutbinding:');
      console.log(element);
      return console.log(ko.toJS(valueAccessor()));
    }
  };

}).call(this);
