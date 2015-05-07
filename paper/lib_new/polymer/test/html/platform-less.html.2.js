
      if (!(window.HTMLImports && HTMLImports.useNative) ||
          !document.documentElement.createShadowRoot ||
          !document.registerElement) {
        done();
      } else {
        addEventListener('polymer-ready', function() {
          chai.assert.equal(elementsReadied, 2, 'imported elements upgraded');
          done();
        });
      }
    