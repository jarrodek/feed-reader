
    document.addEventListener('WebComponentsReady', function() {
      var sheet = document.querySelector('[shim-shadowdom-css]');
      //chai.assert.notMatch(sheet.textContent, /polyfill-next-selector/, 'polyfill rules properly replaced');
      //chai.assert.notMatch(sheet.textContent, /-shadowcsshost/, 'polyfill rules properly replaced');
      done();
    });
  