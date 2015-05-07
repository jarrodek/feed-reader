
    XButton = $class(HTMLButtonElement, {
      readyCallback: function() {
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
      prototype: XButton.prototype
    });
    document.body.appendChild(new XButton()).textContent = 'Hello World';
  