
        (function() {
          Polymer('x-test', {
            bar: '',
            observe: {
              bar: 'validate',
              pie: 'validate',
              'a.b.c': 'validateSubPath'
            },
            ready: function() {
              this.bar = 'bar';
              this.pie = 'pie';
              this.a = {b: {c: 'exists'}};
            },
            barChanged: function() {
              //console.log('I should not be called')
            },
            validate: function() {
              //console.log('validate');
              chai.assert.equal(this.bar, 'bar', 'custom change observer called');
              chai.assert.equal(this.pie, 'pie', 'custom change observer called');
              checkDone();
            },
            validateSubPath: function(oldValue, newValue) {
              //console.log('validateSubPath', oldValue, newValue);
              chai.assert.equal(newValue, 'exists', 'subpath change observer called');
              checkDone();
            }
          });
        })();
      