

function Circle(radius) {
  // circumference = 2*PI*radius
  constrain(this, {
    radius: function() { return this.circumference / (2*Math.PI); },
    circumference: function() { return 2 * Math.PI * this.radius; }
  });

  // area = PI*r^2'
  constrain(this, {
    area: function() { return Math.PI * Math.pow(this.radius, 2); },
    radius: function() { return Math.sqrt(this.area / Math.PI); }
  });

  if (radius)
    this.radius = radius;
}

function CircleController(elm) {
  this.circles = elm.model = persistDB.retrieve(Circle);
}

CircleController.prototype = {
  delete: function(circle) {
    var index = this.circles.indexOf(circle);
    this.circles.splice(index, 1);
  },

  add: function() {
    this.circles.push(new Circle());
  }
}

