
        Polymer('x-foo', {
          fooish: true,
          domReady: function() {
            chai.assert.isTrue(this.firstElementChild.isBar, 'child is not upgraded');
            chai.assert.isTrue(this.previousElementSibling.isBar, 'sibling is not upgraded');
            chai.assert.isTrue(this.nextElementSibling.isBar, 'sibling is not upgraded');
            done();
          }
        });
      