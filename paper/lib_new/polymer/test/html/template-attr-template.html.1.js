
    Polymer('decoration-test2', {
      arrs: [ [1,2,3], [4,5,6] ],
      test: function() {
        chai.assert.equal(this.$.tbody.children.length, 3, 'attribute template stamped');
        chai.assert.equal(this.$.tbody.children[1].children.length, 4, 'attribute sub-template stamped');
      }
    });
  