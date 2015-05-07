
    Polymer('x-bar', {
      label: "tabula rasa",
      ready: function() {
        this.update();
      },
      update: function() {
        this.textContent = this.label;
      }
    });
  