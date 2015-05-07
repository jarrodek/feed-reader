

var assert = chai.assert;
var wrap = ShadowDOMPolyfill.wrap;
var doc = wrap(document);

var div = document.createElement('div');
document.documentElement.appendChild(div);
div.parentNode.removeChild(div);

