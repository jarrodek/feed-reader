
    var assert = chai.assert;
    addEventListener('polymer-ready', function() {
      var d = location.href.split('/').slice(0, -1).join('/') + '/';
      var xri = document.querySelector('#xri');
      assert.equal(xri.$.image.src, new URL('resolve/images/foo', document.baseURI).href);
      assert.equal(xri.resolvePath('foo.js'), d + 'resolve/foo.js');
      assert.equal(xri.resolvePath('foo/bar'), d + 'resolve/foo/bar');
      assert.equal(xri.resolvePath('http://example.com/foo'), 'http://example.com/foo');
      var xriap = document.querySelector('#xri-ap');
      assert.equal(xriap.resolvePath('foo.js'), d + 'resolve/foo/bar/baz/foo.js');
      assert.equal(xriap.resolvePath('foo/bar/foo.js'), d +
                   'resolve/foo/bar/baz/foo/bar/foo.js');
      assert.equal(xriap.resolvePath('http://example.com/foo'), 'http://example.com/foo');
      done();
    });
  