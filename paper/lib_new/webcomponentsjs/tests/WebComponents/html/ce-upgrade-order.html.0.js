
    addEventListener('WebComponentsReady', function() {
      // native CE will upgrade in creation order
      // HTMLImports polyfill must be created after main document
      // Therefore, skip this test in that scenario
      if (CustomElements.useNative && !HTMLImports.useNative) {
        return done();
      }
      var proto = Object.create(HTMLElement.prototype);
      var order = [];
      proto.createdCallback = function() {
        order.push(this.id);
      }
      document.registerElement('x-foo', {prototype: proto});
      chai.assert.deepEqual(order, ['import', 'main'], 'elements are upgraded in imports before main document');
      done();
    });
  