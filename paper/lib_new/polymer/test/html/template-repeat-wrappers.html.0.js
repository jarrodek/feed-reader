
  document.addEventListener('HTMLImportsLoaded', function() {
    var template = document.querySelector('#template');

    var host = document.querySelector('#foo');
    var root = host.createShadowRoot();
    root.appendChild(template.content);

    var m = [
      {label: 'item1'},
      {label: 'item2'}
    ];

    host.shadowRoot.querySelector('#t').model = m;

    // TODO(sjmiles): forcing SD to render at this point is not necessary, 
    // except to understand why it causes a failure at the assertion
    host.offsetHeight;
    var list = host.shadowRoot.querySelector('#list');

    new MutationObserver(function() {
      chai.assert.equal(list.children.length, 3, 'list.children.length (should be 3 but returns 1)');  
      done();
    }).observe(list, {childList: true});
  });
