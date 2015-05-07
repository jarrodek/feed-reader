
        Polymer('x-zot', {
          ready: function() {
            chai.assert.equal(this.shadowRoots['x-foo'].querySelector('#foo'),
                this.$.foo);
            chai.assert.equal(this.shadowRoots['x-bar'].querySelector('#bar'),
                this.$.bar);
            chai.assert.equal(this.shadowRoots['x-zot'].querySelector('#zot'),
                this.$.zot);
            done();
          }
        });
      