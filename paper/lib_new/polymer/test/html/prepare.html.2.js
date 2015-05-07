
        Polymer('x-compose', {
          ready: function() {
            var templateBasic = this.fetchTemplate(this.element).content
                .querySelector('x-basic');
            chai.assert.isFalse(Boolean(templateBasic._elementPrepared), 
                'template element not prepared');
            chai.assert.isTrue(this.$.basic._elementPrepared, 
                'sub-elements prepared by ready time');
            this.onMutation(this.shadowRoot, function() {
              var inits = this.shadowRoot.querySelectorAll('x-bind-init');
              for (var i=0, ii; (i<inits.length) && (ii=inits[i]); i++) {
                chai.assert.isTrue(ii.sawStuffChanged, 'binding while inert triggered side effect');
              }
              done();
            });
            this.things = [
              {stuff: 0},
              {stuff: 1},
              {stuff: 2}
            ];
          }
        });
      