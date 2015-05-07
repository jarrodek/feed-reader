
      Polymer('mdv-repeat', {
        runTests: function() {
          var d = this.shadowRoot.querySelectorAll('div');
          for (var i = 0; i < d.length; i++) {
            assert.equal(d[i].textContent, this.test.repeatIn[i].value);
          }
        }
      });
    