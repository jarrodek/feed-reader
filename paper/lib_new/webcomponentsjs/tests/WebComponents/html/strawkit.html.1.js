
      window.addEventListener('WebComponentsReady', function() {
        var assert = chai.assert;
        var elt = document.querySelector('x-foo');
        assert.ok(elt, 'x-foo not found');
        assert.equal(elt.textContent, 'cordon bleu',
            'x-foo has wrong textContent');
        assert.match(elt.style.backgroundColor, /lightblue|rgb\(173, 216, 230\)/,
          'x-foo has wrong backgroundColor');
        assert.ok(elt.shadowRoot, 'shadowRoot not available as `.shadowRoot`');
        done();
      });
    