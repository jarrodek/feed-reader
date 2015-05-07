
      var assert = chai.assert;
      window.addEventListener('WebComponentsReady', function() {
        var p = Object.create(HTMLElement.prototype);
        p.createdCallback = function() {
          this.textContent = 'custom!';
        }
        document.registerElement('x-foo', {prototype: p});
        //
        var p = Object.create(HTMLButtonElement.prototype);
        p.createdCallback = function() {
          this.textContent = 'custom!';
        }
        document.registerElement('x-baz', {prototype: p, extends: 'button'});
        document.body.appendChild(document.createElement('button', 'x-baz')).id = 'baz2';
        //
        assert.equal(document.querySelector('x-foo').textContent, 'custom!',
          'x-foo must have custom text');
        //
        assert.equal(document.querySelector('[is=x-baz]').textContent,
          'custom!', 'button is="x-baz" must have custom text');
        assert.equal(document.querySelector('#baz2').textContent, 'custom!',
          'button is=x-baz can be created via document.createElement(button, x-baz)');
        //
        var p = Object.create(HTMLElement.prototype);
        p.attachedCallback = function() {
          this.textContent = 'custom!';
        }
        //
        document.registerElement('x-zot', {prototype: p});
        //
        var xfoo = document.querySelector('x-foo');
        var root = xfoo.createShadowRoot();
        var xzot = document.createElement('x-zot');
        var handler = function() {
          assert.equal(xzot.textContent, 'custom!', 'x-zot in shadow root must have custom text');
          done();
        }
        var ob = new MutationObserver(handler);
        ob.observe(root, {childList: true, subtree: true});
        root.appendChild(xzot);
      });
    