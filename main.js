// Generated by CoffeeScript 1.7.1
(function() {
  var viewModel;

  String.prototype.capitalize = function() {
    return this.replace(/^./, function(letter) {
      return letter.toUpperCase();
    });
  };

  viewModel = {
    servers: ['Rushu'],
    loadData: function(server) {
      return function(callback) {
        return $.getJSON("//api.dofusportal.tk/" + server, function(data) {
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
          return callback(data);
        });
      };
    }
  };

  window.viewModel = viewModel;

  $(function() {
    pager.extendWithPage(viewModel);
    ko.applyBindings(viewModel);
    return pager.start();
  });

}).call(this);