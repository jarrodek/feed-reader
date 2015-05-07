
      (function() {
        var proto = Object.create(HTMLElement.prototype);
        proto.createdCallback = function() {
          elementsCreated++;
        }

        document.registerElement('x-foo', {prototype: proto});
      })();
    