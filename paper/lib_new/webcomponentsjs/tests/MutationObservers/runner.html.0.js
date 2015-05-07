

mocha.setup({
  ui: 'tdd',
  ignoreLeaks: true
});

var assert = chai.assert;

function assertArrayEqual(a, b, msg) {
  assert.equal(a.length, b.length, msg);
  for (var i = 0; i < a.length; i++) {
    assert.equal(a[i], b[i], msg);
  }
}

var expectRecord = (function() {
  var useNative = /native/.test(location.search);
  var isWebKit = /WebKit/.test(navigator.userAgent);
  var slice = Array.prototype.slice.call.bind(Array.prototype.slice);

  if (useNative) {
    JsMutationObserver =
        window.MutationObserver || window.WebKitMutationObserver;
  }

  // addedNodes/removedNodes are broken in WebKit.
  // https://bugs.webkit.org/show_bug.cgi?id=98921
  function fixWebKitNodes(nodes) {
    if (nodes === null && useNative && isWebKit)
      return [];
    return nodes;
  }

  return function expectRecord(record, expected) {
    assert.strictEqual(record.type,
        expected.type === undefined ? null : expected.type);
    assert.strictEqual(record.target,
        expected.target === undefined ? null : expected.target);
    assertArrayEqual(fixWebKitNodes(record.addedNodes),
        expected.addedNodes === undefined ? [] : expected.addedNodes);
    assertArrayEqual(fixWebKitNodes(record.removedNodes),
        expected.removedNodes === undefined ? [] : expected.removedNodes);
    assert.strictEqual(record.previousSibling,
        expected.previousSibling === undefined ?
            null : expected.previousSibling);
    assert.strictEqual(record.nextSibling,
        expected.nextSibling === undefined ? null : expected.nextSibling);
    assert.strictEqual(record.attributeName,
        expected.attributeName === undefined ? null : expected.attributeName);
    assert.strictEqual(record.attributeNamespace,
        expected.attributeNamespace === undefined ?
            null : expected.attributeNamespace);
    assert.strictEqual(record.oldValue,
        expected.oldValue === undefined ? null : expected.oldValue);
  };
})();

