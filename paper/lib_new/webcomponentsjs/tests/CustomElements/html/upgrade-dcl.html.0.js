
      var created = [];
      function registerTestElement(name) {
        var p = Object.create(HTMLElement.prototype);
        p.createdCallback = function() {
          created.push(this.localName);
        };
        document.registerElement(name, {prototype: p});
      }

      registerTestElement('x-foo');

      addEventListener('DOMContentLoaded', function() {
        registerTestElement('x-bar');
      });

      addEventListener('WebComponentsReady', function() {
        chai.assert.equal(created.length, 2, 'elements registered a DOMContentLoaded time are upgraded');
        done();
      });
    