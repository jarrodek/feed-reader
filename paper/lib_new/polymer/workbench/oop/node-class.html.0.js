
    Button = $class(HTMLButtonElement, {
      constructor: function() {
        this.emit('[Construct Base]')
      },
      emit: function(inMsg) {
        document.body.appendChild(document.createTextNode(inMsg));
      },
      soundOff: function() {
        this.emit('[Base]');
      } 
    });
    b = new Button();
    b.soundOff();
  