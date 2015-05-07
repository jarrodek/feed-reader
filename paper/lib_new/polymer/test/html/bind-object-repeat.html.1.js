
        Polymer('x-bind-obj', {
          testObj: null,
          arr: null,
          ready: function() {
            this.testObj = {foo: 'single'};
            this.arr = [
              {foo: 'array 0'},
              {foo: 'array 1'},
              {foo: 'array 2'}
            ];
            this.onMutation(this.$.container, function() {
              this.test();
            });
          },
          test: function() {
            chai.assert.equal(this.$.foo.obj, this.testObj);
            function checkXFoo(xFoo) {
              var p = xFoo.shadowRoot.querySelector('p');
              chai.assert.isDefined(xFoo.obj.foo);
              chai.assert.equal(p.innerHTML, 'obj.foo is ' + xFoo.obj.foo);
            }
            checkXFoo(this.$.foo);
            var xfoos = this.$.container.querySelectorAll('x-foo');
            chai.assert.equal(xfoos.length, 3, 'there should be 3 xfoos from the repeat');
            Array.prototype.forEach.call(xfoos, function(x) {
              checkXFoo(x);
            });
            done();
          }
        });
      