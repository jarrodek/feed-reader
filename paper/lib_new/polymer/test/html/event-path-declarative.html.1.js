
        Polymer('x-foo', {
          contentTestEventHandler: function(e, detail, sender) {
            //console.log('%s on %s in %s, (3)', e.type, sender.id, this.localName);
            testEvent(sender);
          },
          divTestEventHandler: function(e, detail, sender) {
            //console.log('%s on %s in %s, (7)', e.type, sender.id, this.localName);
            testEvent(sender);
          },
          testEventHandler: function(e, detail, sender) {
            //console.log('%s on %s host event (8)', e.type, this.localName);
            testEvent(sender);
          }
        });
      