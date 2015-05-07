
    Base = $class({
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
    //
    Sub = $class(Base, {
      constructor: function() {
        this.super();
        this.emit('[Construct Sub]')
      },
      soundOff: function() {
        this.emit('[Sub]');
        this.super();
      } 
    });
    //
    SubSub = $class(Sub, {
      constructor: function() {
        this.super();
        this.emit('[Construct SubSub]')
      },
      soundOff: function() {
        this.emit('[SubSub]');
        this.super();
      } 
    });
    //
    subsub = new SubSub();
    subsub.soundOff();
  