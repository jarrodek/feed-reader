

  document.addEventListener('HTMLImportsLoaded', function() {
    // NOTE: IE requires asynchrony here
    setTimeout(function() {
      var i = document.querySelector('[rel=import]');
      var doc = i.import;

      var red = document.querySelector('.red');
      chai.assert.equal(getComputedStyle(red).backgroundColor, 'rgb(255, 0, 0)', 'style in @import applied');
      var image = document.querySelector('.image');

      // document relative image url
      var a = document.createElement('a');
      a.href = 'imports/google.png';
      chai.assert.match(getComputedStyle(image).backgroundImage, new RegExp(a.href), 'url in style applied');

      if (!HTMLImports.useNative) {
        var style = document.querySelector('style');
        chai.assert.ok(style.sheet);
        chai.assert.equal(style.sheet.cssRules[2].href,
            'http://fonts.googleapis.com/css?family=Open+Sans:300,300italic,600,800|Source+Code+Pro',
            '@import url() form rule has proper url')
      }

      done();
    });
  });
  