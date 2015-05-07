
    var Base = function() {
    };
    Base.prototype = {
      super: $super,
      emit: function(inMsg) {
        document.body.appendChild(document.createTextNode(inMsg));
      },
      soundOff: function() {
        this.emit('[Base]');
      }
    };
    //
    var Sub = function() {
    };
    Sub.prototype = Object.create(Base.prototype);
    Sub.prototype.soundOff = function() {
      this.emit('[Sub]')
      this.super();
    };
    //
    var SubSub = function() {
    };
    SubSub.prototype = Object.create(Sub.prototype);
    SubSub.prototype.soundOff = function() {
      this.emit('[SubSub]');
      this.super();
    };
    //
    var subsub = new SubSub();
    subsub.soundOff();
  