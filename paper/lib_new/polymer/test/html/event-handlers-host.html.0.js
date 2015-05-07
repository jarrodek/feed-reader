
      Polymer('x-test-host', {
        hostTapAction: function(e) {
          e.tapped = 1;
          e.stopPropagation();
        }
      });
    