
      HTMLImports = {};

      var elementsCreated = 0;

      addEventListener('load', function() {
        setTimeout(function() {
          document.dispatchEvent(new CustomEvent('HTMLImportsLoaded', {bubbles: true}));
          // parsing hook available
          chai.assert.ok(HTMLImports.__importsParsingHook, 'imports parsing hook installed');
          //
          var doc = document.implementation.createHTMLDocument('Foo');
          doc.body.innerHTML = '<x-foo></x-foo>';
          var link = document.createElement('mock-link');
          link.import = doc;
          HTMLImports.__importsParsingHook(link);
          //
          addEventListener('WebComponentsReady', function() {
            chai.assert.equal(2, elementsCreated, 'HTML hook allows main document and import document to upgrade');
            done();
          })
        }, 1);
      });
    