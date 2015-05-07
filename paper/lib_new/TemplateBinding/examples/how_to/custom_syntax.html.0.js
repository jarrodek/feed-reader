
    document.addEventListener('DOMContentLoaded', function() {
      var delegate = {
        getBinding: function(model, path, name, node) {
          var twoXPattern = /2x:(.*)/
          var match = path.match(twoXPattern);
          if (match == null)
            return;

          path = match[1].trim();
          var binding = new CompoundBinding(function(values) {
            return values['value'] * 2;
          });

          binding.bind('value', model, path);
          return binding;
        }
      };

      var t = document.getElementById('example');
      t.bindingDelegate = delegate;
      t.model = {
        value: 4
      };

      // Needed to detect model changes if Object.observe
      // is not available in the JS VM.
      Platform.performMicrotaskCheckpoint();
    });
    