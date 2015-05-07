
      var events = [
        // base events
        'down',
        'up',
        'trackstart',
        'track',
        'trackend',
        'tap',
        'hold',
        'holdpulse',
        'release'
      ];
      function find(/*...inEls*/) {
        [].forEach.call(arguments, function(e) {
          window[e] = document.getElementById(e);
        });
      }
      function appendOutput(inString) {
        var it = output.textContent;
        output.textContent = inString + '\n' + it;
      }
      find('capture', 'output', 'enterleave');
      events.forEach(function(en) {
        PolymerGestures.addEventListener(capture, en, function(inEvent) {
          appendOutput(inEvent.type + ' [' + inEvent.pointerId + ']');
          inEvent.preventDefault();
        });
      });
    