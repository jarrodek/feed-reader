
    Base = function() {};
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
    Sub = function() {};
    Sub.prototype = extend(Base.prototype, {
      soundOff: function() {
        this.emit('[Sub]');
        this.super();
      }
    });
    //
    SubSub = function() {};
    SubSub.prototype = extend(Sub.prototype, {
      soundOff: function() {
        this.emit('[SubSub]');
        this.super();
      }
    });
    //
    subsub = new SubSub();
    subsub.soundOff();
  