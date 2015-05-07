
        Polymer('my-element', {
          publish: { volume: 11 },
          ready: function() {
            var child = this.$.child;
            chai.assert.equal(child.lowercase, 11);
            chai.assert.equal(child.camelCase, 11);

            chai.assert.equal('' + child.lowercase, child.getAttribute('lowercase'));
            chai.assert.equal('' + child.camelCase, child.getAttribute('camelcase'));

            done();
          }
        });
      