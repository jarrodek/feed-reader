
        Polymer('x-bar', {
          created: function() {
            this.super();
            chai.assert.isTrue(this instanceof
                Object.getPrototypeOf(this).constructor);
          },
          domReady: function() {
            this.super();
            chai.assert.isDefined(window.XBar, 'constructor is undefined');
            //chai.assert.isTrue(this.impl instanceof XBar, 'instanceof failed');
            chai.assert.isTrue(CustomElements.instanceof(this, XBar), 'instanceof failed');
            done();
          }
        });
      