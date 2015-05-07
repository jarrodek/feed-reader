
    Polymer('decoration-test', {
      options: [1, 2, 3, 4],
      ready: function() {
        this.test();
        testsRun++;
      },
      test: function() {
        chai.assert.equal(this.$.select.children.length, 5, 'attribute template stamped');
      }
    });
  