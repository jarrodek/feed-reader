
    document.addEventListener('polymer-ready', function() {
      var x1 = document.querySelector('x-one');
      chai.assert.equal(x1.Foo, 'squid');
      var x3 = document.querySelector('x-three');
      chai.assert.equal(x3.Foo, '3');
      chai.assert.equal(x3._observeNames.length, 1, 'x3 should have exactly one observed name');
      done();
    });
  