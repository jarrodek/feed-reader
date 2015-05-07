
    document.addEventListener('polymer-ready', function() {
      var x = document.querySelector('infer-name-main-doc');
      chai.assert.ok(x.isReady);
      //
      var y = document.querySelector('infer-name');
      chai.assert.ok(y.isReady);
      //
      var z = document.querySelector('infer-name-remote-script');
      chai.assert.ok(z.isReady);
      //
      var z1 = document.querySelector('infer-name-remote-script-import');
      chai.assert.ok(z1.isReady);
      done();
    });
  