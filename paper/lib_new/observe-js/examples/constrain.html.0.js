
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
