
        Polymer('x-foo', {
          //alwaysPrepare: true,
          createdCallback: function() {
            //console.log(this.localName + ': createdCallback!');
            this.super();
          },
          attached: function() {
            //console.log(this.localName + ': enteredView!');
          },
          ready: function() {
            //console.log(this.localName + ': created!');
          }
        })
      