
    document.addEventListener('WebComponentsReady', function() {
      var foo = document.querySelector('x-foo');
      var xBarRoot = foo.shadowRoot.querySelector('x-bar').shadowRoot;
      var bar = xBarRoot.querySelector('.bar');
      chai.assert.equal(getComputedStyle(bar).backgroundColor, 'rgb(255, 0, 0)',
        '^ styles are applied (backgroundColor)');

      var noogy = xBarRoot.querySelector('.noogy');
      chai.assert.equal(getComputedStyle(noogy).backgroundColor, 'rgb(0, 0, 255)',
        '^ styles are applied (backgroundColor)');
      var xZot = foo.shadowRoot.querySelector('x-bar').shadowRoot
          .querySelector('x-zot');
      var zot = xZot.shadowRoot.querySelector('.zot');

      chai.assert.equal(getComputedStyle(zot).backgroundColor, 'rgb(0, 128, 0)',
        '^ styles are applied (backgroundColor)');
      chai.assert.equal(getComputedStyle(zot).color, 'rgb(255, 255, 255)',
        '^^ styles are applied (color)');

      // NOTE: native import styles not shimmed under SD polyfill
      var unsupported = window.ShadowDOMPolyfill && HTMLImports.useNative;
      if (!unsupported) {
        var fooDiv = foo.shadowRoot.querySelector('.foo');
        var zotDiv = xZot.shadowRoot.querySelector('.zot-inner');
        var fooDiv2 = foo.shadowRoot.querySelector('.foo2');

        // TODO(sorvell): test blocked on
        // https://code.google.com/p/chromium/issues/detail?id=339657
        //chai.assert.equal(getComputedStyle(fooDiv2).backgroundColor, 'rgb(0, 128, 0)',
        //  'combinators applied via stylesheet in import');

        chai.assert.equal(getComputedStyle(fooDiv).backgroundColor, 'rgb(255, 165, 0)',
            'combinators applied via style in main document');
        chai.assert.equal(getComputedStyle(zotDiv).backgroundColor, 'rgb(0, 0, 255)',
            'combinators applied via stylesheet in main document');
      }
      done();
    });
  