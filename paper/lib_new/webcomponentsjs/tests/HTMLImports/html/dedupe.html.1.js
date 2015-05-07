
      addEventListener('HTMLImportsLoaded', function() {
        chai.assert.equal(dedupe, 1, 'import loaded');
        done();
      });
    