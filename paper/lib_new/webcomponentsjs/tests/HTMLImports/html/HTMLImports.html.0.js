
      // polyfill only test
      if (HTMLImports.useNative) {
        done();
      } else {
        addEventListener('HTMLImportsLoaded', function() {
          chai.assert.equal(5, Object.keys(HTMLImports.importLoader.cache).length,
            'must cache exactly nine resources');
          chai.assert.equal(5, Object.keys(HTMLImports.importer.documents).length,
            'must cache exactly nine documents');

          Object.keys(HTMLImports.importer.documents).forEach(function(key) {
            var doc = HTMLImports.importer.documents[key];
            if (!doc) {
              return;
            }
            var links = doc.querySelectorAll('link[rel=import]');
            Array.prototype.forEach.call(links, function(link) {
              var href = link.getAttribute('href');
              if (href.indexOf('404') <= 0) {
                chai.assert.isDefined(link.import, 'import should have an import property');
              }
            });
          });

          done();
        });

      }
    