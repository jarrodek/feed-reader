
        Polymer('x-target', {
          // force an mdv binding
          bind: function() {
            return Element.prototype.bind.apply(this, arguments);
          },
          attached: function() {
            this.testSrcForMustache();
          },
          attributeChanged: function(name, oldValue) {
            this.testSrcForMustache();
            if (this.getAttribute(name) === '../testSource') {
              done();
            }
          },
          testSrcForMustache: function() {
            chai.assert.notMatch(this.getAttribute('src'), Polymer.bindPattern,
              'attribute does not contain {{...}}');
          }
        });
      