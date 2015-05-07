
        Polymer('x-inner', {
          barChanged: function() {
            chai.assert.equal(this.bar.foo, 'foo!');
            done();
          }
        });
      