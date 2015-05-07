
        Polymer('bind-properties-test', {
          myVal: null,
          ready: function() {
            this.obj = {
              path: { to: { value: 3 }}
            };
            this.test();
          },
          test: function() {
            var foo = this.$.foo;
            var bar = this.$.foo.$.bar;
            var bat = this.$.foo.$.bat;
            var baz = this.$.foo.$.bar.$.baz;

            chai.assert.equal(foo.val, 3);
            chai.assert.equal(bar.val, 3);
            chai.assert.equal(bat.val, 3);
            chai.assert.equal(baz.val, 3);

            foo.val = 4;

            chai.assert.equal(foo.val, 4);
            chai.assert.equal(bar.val, 4);
            chai.assert.equal(bat.val, 4);
            chai.assert.equal(baz.val, 4);

            baz.val = 5;

            chai.assert.equal(foo.val, 5);
            chai.assert.equal(bar.val, 5);
            chai.assert.equal(bat.val, 5);
            chai.assert.equal(baz.val, 5);

            this.obj.path.to.value = 6;

            chai.assert.equal(foo.val, 6);
            chai.assert.equal(bar.val, 6);
            chai.assert.equal(bat.val, 6);
            chai.assert.equal(baz.val, 6);

            done();
          }
        });
      