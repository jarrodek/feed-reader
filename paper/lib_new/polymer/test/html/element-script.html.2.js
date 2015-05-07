
    var assert = chai.assert;
    document.addEventListener('polymer-ready', function() {
      // TODO(sorvell): under CE polyfill, noscript is not ready at WCR time
      // so need timeout or zot test fails.
      setTimeout(function() {
        var foo = document.querySelector('x-foo');
        assert.equal(getComputedStyle(foo).color, 'rgb(0, 0, 255)');
        //
        var bar = document.querySelector('x-bar');
        assert.equal(getComputedStyle(bar).color, 'rgb(0, 0, 255)');
        assert.equal(getComputedStyle(bar).backgroundColor, 'rgb(255, 165, 0)');
        //
        var zot = document.querySelector('x-zot');
        assert.equal(getComputedStyle(zot).color, 'rgb(0, 0, 255)');
        //
        var baz = document.querySelector('x-baz');
        assert.equal(getComputedStyle(baz).color, 'rgb(0, 0, 255)');
        assert.equal(getComputedStyle(baz).backgroundColor, 'rgb(255, 99, 71)');
        //
        var qux = document.querySelector('x-qux');
        assert.equal(getComputedStyle(qux).color, 'rgb(0, 0, 255)');
        assert.equal(getComputedStyle(qux).backgroundColor, 'rgb(0, 128, 0)');
        //
        var quux = document.querySelector('x-quux');
        assert.equal(getComputedStyle(quux).color, 'rgb(0, 0, 255)');
        assert.equal(getComputedStyle(quux).fontSize, '24px');
        done();
      }, 0);
    });
  