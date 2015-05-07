
      Polymer('mdv-bind', {
        runTests: function() {
          var o = this.shadowRoot.querySelector('#output');
          assert.equal(o.textContent, this.test.bindAs.value);
        }
      });
    