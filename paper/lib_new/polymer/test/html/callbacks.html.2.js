
      Polymer('x-repeat', {
        ready: function() {
          this.stuff = [1, 2, 3];
          this.onMutation(this.$.container, function() {
            // TODO(sorvell): SD polyfill mutation observer ordering issue, file bug
            setTimeout(function() {
              var base = this.shadowRoot.querySelector('x-base');
              chai.assert.isTrue(base.isReadied, 'template bind stamped element is ready');
              chai.assert.isTrue(base.isInserted, 'template bind stamped element is enteredView');
              var exts = this.shadowRoot.querySelectorAll('x-exendor');
              for (var i=0, e; (i < exts.length) && (e = exts[i]); i++) {
                chai.assert.isTrue(e.isReadied, 'template repeat stamped element is ready');
                chai.assert.isTrue(e.isInserted, 'template repeat stamped element is enteredView');
              }
              done();
            }.bind(this));
          });
        }
      });
    