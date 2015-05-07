
    Polymer('x-foo', {
      label: '',
      ready: function(root) {
        this.textContent = 'cordon bleu';
        this.blueate();
      },
      blueate: function() {
        this.style.backgroundColor = 'lightblue';
      }
    });
  