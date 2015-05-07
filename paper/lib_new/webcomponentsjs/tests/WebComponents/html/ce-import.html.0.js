
      window.addEventListener('WebComponentsReady', function() {
        // native imports + shadowdom polyfill is not supported so just pass
        if (HTMLImports.useNative && window.ShadowDOMPolyfill) {
          done();
          return;
        }
        var xfoo = document.querySelector('x-foo');
        chai.assert.isUndefined(xfoo.isCreated);
        var link = document.createElement('link');
        link.rel = 'import';
        link.href = 'element-import.html';
        document.head.appendChild(link);
        HTMLImports.whenReady(function() {
          chai.assert.isTrue(xfoo.isCreated, 'element in main document, registered in dynamic import is upgraded');
          var ix = link.import.querySelector('x-foo');
          chai.assert.isTrue(ix.isCreated, 'element in import, registered in dynamic import is upgraded');
          done();
        });
      });
    