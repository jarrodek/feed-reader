
        (function() {
          var changes = 0;
          var doneChanges = 3;
          function checkDone() {
            if (doneChanges == ++changes) {
              done();
            }
          }
          
          Polymer('x-test', {
            bar: '',
            attributeChangedCount: 0,
            ready: function() {
              this.attribute = 'foo';
              this.deliverChanges();
              chai.assert.equal(this.attributeChangedCount, 0, 'attributeChanged does not observe property attribute');
              this.setAttribute('nog', 'nog');
              this.bar = 'bar';
              setTimeout(function() {
                this.zonk = 'zonk';
              }.bind(this));
            },
            barChanged: function() {
              chai.assert.equal(this.bar, 'bar', 'change in ready calls *Changed');
              checkDone();
            },
            zonkChanged: function() {
              chai.assert.equal(this.zonk, 'zonk', 'change calls *Changed without prototype value')
              checkDone();
            },
            attributeChanged: function() {
              this.attributeChangedCount++;
              chai.assert.equal(this.getAttribute('nog'), 'nog', 'attributeChanged called in response to an attribute value changing')
              checkDone();
            }
          });
        })();
      