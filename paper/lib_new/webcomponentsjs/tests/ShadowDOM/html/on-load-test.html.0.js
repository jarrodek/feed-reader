

var assert = chai.assert;
var wrap = ShadowDOMPolyfill.wrap;

window.addEventListener('load', function(e) {
  assert.equal(e.target, wrap(document))
  assert.equal(e.currentTarget, wrap(window));
  assert.equal(this, wrap(window));
  assert.equal(e.eventPhase, Event.AT_TARGET);

  done();
});

