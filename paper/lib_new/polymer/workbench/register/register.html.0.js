
    XButton = $class(HTMLButtonElement, {
      constructor: function() {
        this.emit('[Construct Base]')
        this.textContent = "XButton";
      },
      emit: function(inMsg) {
        document.body.appendChild(document.createTextNode(inMsg));
      },
      soundOff: function() {
        this.emit('[Base]');
      } 
    });
    XButton = document.register('x-button', {
      extends: 'button',
      prototype: XButton.prototype,
      lifecycle: {
        readyCallback: XButton.prototype.constructor
      }
    });
    document.body.appendChild(new XButton()).textContent = 'Hello World';
  