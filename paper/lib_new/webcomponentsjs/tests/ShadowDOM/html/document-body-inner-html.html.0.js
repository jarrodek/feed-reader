

var assert = chai.assert;
var wrap = ShadowDOMPolyfill.wrap;
var doc = wrap(document);

doc.addEventListener('DOMContentLoaded', function(e) {
  var html = '<a></a><b></b>';
  doc.body.innerHTML = html;

  assert.equal(doc.body.innerHTML, html);
  assert.equal(document.body.innerHTML, html);

  done();
});

