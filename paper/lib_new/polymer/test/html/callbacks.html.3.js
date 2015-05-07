
    document.addEventListener('polymer-ready', function() {
      var xBase = document.querySelector('x-base');
      chai.assert.equal(xBase.isReadied, true);
      chai.assert.equal(xBase.isInserted, true);
      xBase.setAttribute('foo', 'foo');
      chai.assert.equal(xBase.hasAttributeChanged, true);
      
      var xExtendor = document.querySelector('x-extendor');
      chai.assert.equal(xExtendor.isReadied, true);
      chai.assert.equal(xExtendor.extendedIsReadied, true);
      chai.assert.equal(xExtendor.isInserted, true);
      chai.assert.equal(xExtendor.extendedIsInserted, true);
      xExtendor.setAttribute('foo', 'foo');
      chai.assert.equal(xExtendor.hasAttributeChanged, true);
      chai.assert.equal(xExtendor.extendedHasAttributeChanged, true);
      
      xBase.parentNode.removeChild(xBase);
      xExtendor.parentNode.removeChild(xExtendor);
      // Ensure IE goes...
      CustomElements.takeRecords();
      chai.assert.equal(xBase.isRemoved, true);
      chai.assert.equal(xExtendor.isRemoved, true);
      chai.assert.equal(xExtendor.extendedIsRemoved, true);
    });
  