
      chai.assert.equal(document._currentScript.parentNode, document.body, '_currentScript set in main document');
      addEventListener('HTMLImportsLoaded', function() {
        chai.assert.equal(window.remoteCurrentScriptExecuted, 2, 'remote script executed from import and main document');
        done();
      });
    