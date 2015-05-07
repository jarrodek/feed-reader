
      Polymer('x-test', {
        attached: function() {
          this.onMutation(this.shadowRoot, function() {
            // tickle SD polyfill
            this.offsetHeight;
            var children = this.$.echo.children;
            chai.assert.equal(children[0].localName, 'template',
              'shadowDOM dynamic distribution via template');
            chai.assert.equal(children[1].textContent, 'foo',
              'shadowDOM dynamic distribution via template');
            chai.assert.equal(children[2].textContent, 'bar',
              'shadowDOM dynamic distribution via template');
            chai.assert.equal(this.$.echo.children.length, 3,
              'expected number of actual children');
            done();
          });
          this.list = [
            {name: 'foo'},
            {name: 'bar'}
          ];
          Platform.flush();
        }
      });
    