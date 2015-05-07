
      eventPath = [];
      testEvent = function(node) {
        chai.assert.equal(node, eventPath[0], 'Event fired in expected order');
        eventPath.shift();
        // remove shadowRoots since not part of test.
        while (!eventPath[0].localName) {
          eventPath.shift();
        }
      }
      
      document.addEventListener('polymer-ready', function(e) {
        if (e.path) {
          var target = document.querySelector('#target');
          target.dispatchEvent(new CustomEvent('test-event', {bubbles: true}));
        } else {
          console.log('skipping event.path test since it\'s not supported');
        }
        done();
      });
      
    