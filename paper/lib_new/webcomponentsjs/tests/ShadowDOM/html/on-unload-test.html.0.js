
// Note: this test will navigate away from the page. It is designed to be run
// in an iframe. Use ShadowDOM/test/runner.html?grep=unload for running it by
// itself.

function runTest() {
  var assert = chai.assert;
  var doc = ShadowDOMPolyfill.wrap(document);
  var win = ShadowDOMPolyfill.wrap(window);

  // Note: IE gives `window` as the target for beforeunload/unload. Others give
  // document. It's not clear than anyone gets it right, my reading of the
  // current spec is target should be window for beforeunload, but is overridden
  // to be document for unload. Both events are dispatched on window:
  // http://www.whatwg.org/specs/web-apps/current-work/multipage/browsers.html#unloading-documents
  var expectedTarget = /Trident/.test(navigator.userAgent) ? win : doc;

  var beforeunloadCalled = 0;
  window.addEventListener('beforeunload', function(e) {
    beforeunloadCalled++;
    assert.equal(e.target, expectedTarget);
  });

  window.addEventListener('unload', function(e) {
    assert.equal(beforeunloadCalled, 1);
    assert.equal(e.target, expectedTarget);
    done();
  });

  location.href = 'about:blank';
}

document.addEventListener('DOMContentLoaded', function(e) {
  // Note: setTimeout makes IE happy. If document.readyState == 'interactive'
  // at the time we run the tests, IE won't fire an unload in the iframe.
  setTimeout(runTest, 0);
});

