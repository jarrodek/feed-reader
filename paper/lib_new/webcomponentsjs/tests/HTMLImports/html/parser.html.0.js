
      addEventListener('HTMLImportsLoaded', function() {
        chai.assert.ok(window.inlineScriptParsed, 'inlineScriptParsed');
        chai.assert.ok(window.externalScriptParsed, 'externalScriptParsed');
        chai.assert.equal(window.uc, '\u2661 \u34A8', 'unicode matches');
        done();
      });
    