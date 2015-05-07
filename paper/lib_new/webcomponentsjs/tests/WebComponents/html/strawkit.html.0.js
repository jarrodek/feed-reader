
        Polymer.register(this, {
          created: function() {
            this.textContent = 'cordon bleu';
            this.blueate();
          },
          blueate: function() {
            this.style.backgroundColor = 'lightblue';
          }
        });
      