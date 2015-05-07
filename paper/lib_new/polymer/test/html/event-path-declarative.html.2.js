
        Polymer('x-bar', {
          contentTestEventHandler: function(e, detail, sender) {
            eventPath.shift();
            testEvent(sender);
            //console.log('%s on %s in %s, (1)', e.type, sender.id, this.localName);
          },
          divTestEventHandler: function(e, detail, sender) {
            //console.log('%s on %s in %s, (2)', e.type, sender.id, this.localName);
            testEvent(sender);
          },
          testEventHandler: function(e, detail, sender) {
            //console.log('%s on %s host event (9)', e.type, this.localName);
            testEvent(sender);
          }
        });
      