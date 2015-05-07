
      var events = [
        // base events
        'pinch',
        'pinchstart',
        'pinchend',
        'rotate'
      ];
      find('capture', 'output');
      events.forEach(function(en) {
        PolymerGestures.addEventListener(capture, en, function(inEvent) {
          appendOutput(inEvent.type + ' [' + inEvent.scale + ']');
          inEvent.preventDefault();
        });
      });
      function find(/*...inEls*/) {
        [].forEach.call(arguments, function(e) {
          window[e] = document.getElementById(e);
        });
      }
      function appendOutput(inString) {
        var it = output.textContent;
        output.textContent = inString + '\n' + it;
      }
    