
    (function() {
      if (hasShadowDOM) {
        var elementsCreated = 0;
        // basic proto
        var proto = Object.create(HTMLElement.prototype);
        proto.createdCallback = function() {
          elementsCreated++;
        };
        // extend to create shadowRoot containing a custom element
        var hostProto = Object.create(proto);
        hostProto.createdCallback = function() {
          proto.createdCallback.call(this);
          chai.assert.equal(elementsCreated, 1, 'upgraded element');
          var root = this.createShadowRoot();
          // create element via innerHTML
          root.innerHTML = '<x-foo></x-foo>';
          CustomElements.takeRecords(root);
          chai.assert.equal(elementsCreated, 2, 'upgraded element inside shadowRoot');
          // now create async to test if the shadowRoot MutationObserver sees
          setTimeout(function() {
            root.innerHTML = '<x-foo></x-foo>';
            CustomElements.takeRecords(root);
            chai.assert.equal(elementsCreated, 3, 'upgraded element created async inside shadowRoot');
            done();
          }, 50);

        };
        document.registerElement('x-foo', {prototype: proto});
        document.registerElement('x-host', {prototype: hostProto});
      } else {
        done();
      }
    })();
  