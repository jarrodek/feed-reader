
    document.addEventListener('polymer-ready', function() {
      setTimeout(function() {
        item1 = document.querySelector('#item1');
        menuButton = document.querySelector('#menuButton');
        menu = menuButton.$.menu;

        path = [
          item1,
          menuButton.$.menuButtonContent,
          menu.$.selectorContent,
          menu.$.selectorDiv,
          menu.shadowRoot.olderShadowRoot,
          menu.$.menuShadow,
          menu.$.menuDiv,
          menu.shadowRoot,
          menu,
          menuButton.$.menuButtonDiv,
          menuButton.$.overlay.$.overlayContent,
          menuButton.$.overlay.shadowRoot,
          menuButton.$.overlay,
          menuButton.shadowRoot,
          menuButton
        ];
        var x = 0;
        path.forEach(function(n, i) {
          n.addEventListener('x', function(e) {
            //console.log(e.currentTarget.id, x, i);
            chai.assert.equal(e.currentTarget.id, n.id, 'menu current target is as expected');
            chai.assert.equal(x++, i, 'event listener order is correct');
            if (i == path.length-1) {
              done();
            }
          });
        });

        item1.dispatchEvent(new Event('x', {bubbles: true}));
      }, 0);
    })
  