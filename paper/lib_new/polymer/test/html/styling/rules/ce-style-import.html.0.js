
  (function() {
    var ownerDocument = document._currentScript.ownerDocument;
    var t = ownerDocument.querySelector('template');
    var proto = Object.create(HTMLElement.prototype);
    proto.createdCallback = function() {
      var sr = this.createShadowRoot();
      var links = t.content.querySelectorAll('link[rel="stylesheet"]');
      for (var i = 0, l; i < links.length; i++) {
        l = links[i];
        var url = new URL(l.getAttribute('href'), ownerDocument.baseURI);
        var s = document.createElement('style');
        s.textContent = '@import "' + url.href + '";';
        t.content.replaceChild(s, l);
      }
      var styles = t.content.querySelectorAll('style').array();
      Polymer.styleResolver.loadStyles(styles, t.ownerDocument.baseURI, function() {
        sr.appendChild(t.content.cloneNode(true));
        this.dispatchEvent(new CustomEvent('custom-style-loaded', {bubbles: true}));
      });
    };
    document.registerElement('custom-style', {prototype: proto});
  })();
