
      var created = 0;
      function register() {
        var proto = Object.create(HTMLElement.prototype);
        proto.createdCallback = function() {
          created++;
        };
        document.registerElement('x-test', {prototype: proto});
      }

      if (CustomElements.useNative || HTMLImports.useNative) {
        done();
      } else {
        window.addEventListener('WebComponentsReady', function() {
          CustomElements.ready = false;
          register();
          chai.assert.equal(created, 0, 'no elements created when ready explicitly set to false');
          CustomElements.upgradeDocumentTree(document);
          chai.assert.equal(created, 3, 'elements in document tree upgraded via CustomElements.upgradeDocumentTree');
          done();
        });
      }
    