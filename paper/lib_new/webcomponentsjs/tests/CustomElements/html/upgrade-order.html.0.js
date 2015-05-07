
      var created = [];
      var attached = [];

      function registerTestElement(name) {
        var p = Object.create(HTMLElement.prototype);
        p.createdCallback = function() {
          created.push(this.localName);
        };
        p.attachedCallback = function() {
          attached.push(this.localName);
        };
        p.custom = true;
        document.registerElement(name, {prototype: p});
      }

      registerTestElement('x-parent');
      registerTestElement('x-child');
      registerTestElement('x-grandchild');

      var order = [
          'x-parent',
          'x-child', 'x-grandchild', 'x-grandchild',
          'x-child', 'x-grandchild', 'x-grandchild',
          'x-parent'
      ];

      addEventListener('WebComponentsReady', function() {
        chai.assert.equal(created.length, order.length, 'created length is correct');
        chai.assert.equal(attached.length, order.length, 'attached length is correct');
        for (var i=0; i< order.length; i++) {
          chai.assert.equal(created[i], order[i]);
          chai.assert.equal(attached[i], order[i]);
        }
        done();
      });
    