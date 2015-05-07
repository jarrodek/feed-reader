
      // This test auto-passes if we're not native so it's ok to avoid this
      // if Polymer doesn't exist here.
      if (window.Polymer) {
        Polymer({
          ready: function() {
            elementsReadied++;
          }
        });
      }
    