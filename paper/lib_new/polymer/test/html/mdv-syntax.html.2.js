
      Polymer('mdv-expression', {
        runTests: function() {
          var d = this.querySelectorAll('div');
          for (var i = 0; i < d.length; i++) {
            assert.equal(d[i].textContent, this.test.math.expected[i]);
          }
          assert.ok(this.querySelector('#conditional'));
          assert.ok(this.querySelector('pre').classList.contains('bar'));
          assert.equal(this.querySelector('#inception').textContent, document.querySelector('mdv-holder').offsetTop);
        }
      });
    