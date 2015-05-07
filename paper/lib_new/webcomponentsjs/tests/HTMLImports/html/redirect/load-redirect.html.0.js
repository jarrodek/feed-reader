
    document.addEventListener('HTMLImportsLoaded', function() {
      chai.assert.ok(window.redirect, 'redirected script ran');
      var l = document.querySelector('link');
      var a = document.createElement('a');
      a.href = 'imports/redirect/load.html';
      chai.assert.match(l.import.baseURI, new RegExp(a.pathname), 'import baseURI redirected');
      setTimeout(function() {
        var bg = getComputedStyle(document.querySelector('#test')).backgroundImage;
        chai.assert.match(bg, /redirect\/googley.png/, 'import image properly referenced');
        done();
      });
    });
  