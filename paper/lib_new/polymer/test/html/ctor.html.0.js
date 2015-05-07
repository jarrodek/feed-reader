
      (function() {
        var nog = function() {};

        Polymer('x-foo', {
          created: function() {
            chai.assert.isTrue(this instanceof
                Object.getPrototypeOf(this).constructor);
          },
          domReady: function() {
            chai.assert.isDefined(window.XFoo, 'constructor is undefined');
            chai.assert.isTrue(CustomElements.instanceof(this, XFoo), 'instanceof failed');
            chai.assert.isFalse(CustomElements.instanceof(this, nog), 'instanceof bugus base succeeded');
          }
        });
      })();
      