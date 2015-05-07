
(function() {
  var doc = document._currentScript.ownerDocument;
  setTimeout(function() {
    var script = doc.createElement('script');
    script.textContent = 'window.asyncScript = true;';
    doc.body.appendChild(script);

    var style = doc.createElement('style');
    style.textContent = '#asyncStyled { background: red; }';
    doc.body.appendChild(style);

    // async for MO.
    setTimeout(function() {
      document.dispatchEvent(new CustomEvent('asyncElementsAdded', {bubbles: true}));
    }, 1);
  }, 100);
})();
