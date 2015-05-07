
  document.addEventListener('polymer-ready', function() {
    chai.assert.equal(testsRun, 2, 'decration tests ran');
    done();
  });
