
        Polymer('computed-properties-test', {
          concat: null,
          upper: null,
          ready: function() {
            var foo = this.$.foo;
            chai.assert.equal(foo.shadowRoot.innerHTML, 'a:b:ab:AB');
            chai.assert.equal(this.concat, 'ab');
            chai.assert.equal(this.upper, 'AB');
            chai.assert.equal(foo.concat, 'ab');
            chai.assert.equal(foo.upper, 'AB');
            foo.concat = 'bogus';
            foo.upper = 'bogus';
            chai.assert.equal(this.concat, 'ab');
            chai.assert.equal(this.upper, 'AB');
            chai.assert.equal(foo.concat, 'ab');
            chai.assert.equal(foo.upper, 'AB');
            done();
          }
        })
      