
    Base = function() {
    };
    Base.prototype = {
      emit: function(inMsg) {
        document.body.appendChild(document.createTextNode(inMsg));
      },
      soundOff: function() {
        this.emit('[Base]');
      }
    };
    //
    Sub = function() {
    };
    Sub.prototype = Object.create(Base.prototype);
    Sub.prototype.soundOff = function() {
      this.emit('[Sub]')
      Base.prototype.soundOff.call(this);
    };
    //
    SubSub = function() {
    };
    SubSub.prototype = Object.create(Sub.prototype);
    SubSub.prototype.soundOff = function() {
      this.emit('[SubSub]');
      Sub.prototype.soundOff.call(this);
    };
    //
    subsub = new SubSub();
    subsub.soundOff();
  