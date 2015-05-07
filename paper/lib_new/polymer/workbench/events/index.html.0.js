
      Polymer('x-basic', {
        hostClickHandler: function(inEvent, inDetail, inSender) {
          console.log('clicked on host!', this.localName, inEvent);
        },
        localClickHandler: function(inEvent, inDetail, inSender) {
          console.log('clicked on local div!', this.localName, inEvent);
        },
        localDistributedClickHandler: function(inEvent, inDetail, inSender) {
          console.log('clicked on local div around an insertion point!', this.localName, inEvent);
        }
      });
    