
    addEventListener('HTMLImportsLoaded', function() {

      // NOTE: IE requires asynchrony here
      setTimeout(function() {
        var imp = document.head.querySelector('link[rel=import]');
        chai.assert.ok(imp.import, 'import has content');

        function computedStyle(selector) {
          return getComputedStyle(document.querySelector(selector));
        }
        // styles in stylesheets are applied
        chai.assert.equal(computedStyle('.red').backgroundColor, 'rgb(255, 0, 0)');
        chai.assert.equal(computedStyle('.orange').backgroundColor, 'rgb(255, 165, 0)');
        chai.assert.equal(computedStyle('.blue').backgroundColor, 'rgb(0, 0, 255)');
        // styles in stylesheets are applied in the correct order and overriddable
        chai.assert.equal(computedStyle('.overridden').backgroundColor, 'rgb(0, 0, 0)');
        // styles in style elements are applied
        chai.assert.equal(computedStyle('.styled').backgroundColor, 'rgb(255, 0, 0)');
        // styles in style are applied in the correct order and overriddable
        chai.assert.equal(computedStyle('.overridden-style').backgroundColor, 'rgb(0, 0, 0)');


        done();
      });
    });
  