
  XAnimate = register('x-animate', '', HTMLElement.prototype);
  addEventListener('WebComponentsReady', function() {
    setTimeout(function() {
      var x = document.querySelector('x-animate');
      var a = x.shadowRoot.querySelector('.animate');
      chai.assert.match(getComputedStyle(a).backgroundColor, /\(0, 0, 255/, 'animation ran');
      done();
    }, 100);
  });
