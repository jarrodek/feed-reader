
        Polymer('x-zug', {
          ready: function() {
            this.shadowRoot.addEventListener('test-event', function(e) {
              window.eventPath = Array.prototype.slice.call(e.path || [], 0);
            }, true);
          },
          contentTestEventHandler: function(e, detail, sender) {
            //console.log('%s on %s in %s, (4)', e.type, sender.id, this.localName);
            testEvent(sender);
          },
          divTestEventHandler: function(e, detail, sender) {
            //console.log('%s on %s in %s, (5)', e.type, sender.id, this.localName);
            testEvent(sender);
          },
          testEventHandler: function(e, detail, sender) {
            //console.log('%s on %s host event (6)', e.type, this.localName);
            testEvent(sender);
          }
        });
      