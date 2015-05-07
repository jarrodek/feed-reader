
    XFoo = register('x-foo', '', HTMLElement.prototype);

    document.addEventListener('WebComponentsReady', function() {
      var foo = document.querySelector('x-foo');
      var zonkStyle = getComputedStyle(foo.querySelector('.zonk'));
      chai.assert.equal(zonkStyle.backgroundColor,
        'rgb(255, 0, 0)', 'polyfill-rule, single quote');
      chai.assert.equal(zonkStyle.paddingTop,
        '10px', 'polyfill-rule, double quote');
      chai.assert.equal(zonkStyle.color,
        'rgb(0, 0, 255)', '@polyfill-rule');
      var unscopedStyle = getComputedStyle(document.querySelector('.unscoped'));
      chai.assert.equal(unscopedStyle.backgroundColor,
        'rgb(0, 0, 0)', 'polyfill-unscoped-rule single quote');
      chai.assert.equal(unscopedStyle.paddingTop,
        '20px', 'polyfill-unscoped-rule double quote');
      done();
    });
  