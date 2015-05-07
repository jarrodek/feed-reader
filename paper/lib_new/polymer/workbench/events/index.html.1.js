
      Polymer('x-simple-composed', {
        hostClickHandler: function(inEvent, inDetail, inSender) {
          console.log('clicked on host!', this.localName, inEvent);
        },
        localClickHandler: function(inEvent, inDetail, inSender) {
          console.log('clicked on local div!', this.localName, inEvent);
        }
      });
    