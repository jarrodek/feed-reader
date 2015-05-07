
        Polymer('x-foo', {
          foo: 'foo!',
          ready: function() {
            chai.assert.equal(this.foo, this.$.foo.getAttribute('foo'));
            chai.assert.equal(this.$.bool.getAttribute('foo'), '');
            chai.assert.isFalse(this.$.bool.hasAttribute('foo?'));
            chai.assert.equal(this.$.content.innerHTML, this.foo);
            //
            chai.assert.equal(this.foo, this.$.bar.getAttribute('foo'));
            chai.assert.equal(this.$.barBool.getAttribute('foo'), '');
            chai.assert.isFalse(this.$.barBool.hasAttribute('foo?'));
            chai.assert.equal(this.$.barContent.innerHTML, this.foo);
            done();
          }
        })
      