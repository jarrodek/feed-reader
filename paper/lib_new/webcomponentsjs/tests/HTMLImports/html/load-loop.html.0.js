
      document.addEventListener('HTMLImportsLoaded', function() {
        chai.assert.deepEqual(loaded, ['a', 'b', 'c', 'd']);
        done();
      });
    