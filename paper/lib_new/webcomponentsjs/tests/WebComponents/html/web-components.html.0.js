
      window.addEventListener('HTMLImportsLoaded', function() {
        window.importsOk = true;
      });
      window.addEventListener('WebComponentsReady', function() {
        chai.assert.ok(window.importsOk, 'WebComponentsReady without HTMLImportsLoaded');
        chai.assert.ok(window.importTest, 'import failed to set global value');
        done();
      });
    