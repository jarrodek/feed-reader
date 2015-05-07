
      if (!HTMLImports.useNative) {
        done();
      } else {
        addEventListener('HTMLImportsLoaded', function(e) {
          chai.assert.ok(true, 'HTMLImportsLoaded');
          done();
        });
      }
    