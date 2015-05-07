

var assert = chai.assert;
var wrap = ShadowDOMPolyfill.wrap;
var doc = wrap(document);

doc.addEventListener('DOMContentLoaded', function(e) {

  doc.body.innerHTML = 'You should NOT see this.';

  var sr = doc.body.createShadowRoot();
  var firstStr = 'You should see this';
  var secondStr = '... and you should also see this';
  sr.innerHTML = firstStr + '<content>';

  doc.body.offsetHeight;

  doc.body.innerHTML = secondStr;

  doc.body.offsetHeight;

  assert.equal(doc.body.innerHTML, secondStr);
  assert.equal(sr.firstChild.textContent, firstStr);
  assert.equal(document.body.textContent, firstStr + secondStr);

  done();
});

