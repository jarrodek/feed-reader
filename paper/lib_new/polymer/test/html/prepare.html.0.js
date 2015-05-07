
        Polymer('x-foo', {
          createdCallback: function() {
            this.super(arguments);
            chai.assert.isTrue(this._elementPrepared, 'prepared by end of createdCallback');
          },
          created: function() {
            chai.assert.isFalse(Boolean(this._elementPrepared), 'do not prepare by created time');
          },
          ready: function() {
            chai.assert.isTrue(this._elementPrepared, 'prepared by ready time');
          },
          attached: function() {
            chai.assert.isTrue(this._elementPrepared, 'prepared by attached time');
          }
        });
      