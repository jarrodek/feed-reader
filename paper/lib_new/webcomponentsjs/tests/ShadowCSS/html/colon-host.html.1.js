
    document.addEventListener('WebComponentsReady', function() {
      var foo = document.querySelector('x-foo');
      chai.assert.equal(getComputedStyle(foo).backgroundColor, 'rgb(255, 0, 0)',
        ':host styles matching * are applied (backgroundColor)');

      var foo2 = document.querySelector('x-foo.foo');
      chai.assert.equal(getComputedStyle(foo2).backgroundColor, 'rgb(0, 0, 0)',
        ':host styles are conditionally applied (backgroundColor)');

      var foo3 = document.querySelector('x-foo.foo3');
      var foo3div = foo3.shadowRoot.querySelector('div');
      chai.assert.equal(getComputedStyle(foo3div).backgroundColor, 'rgb(0, 0, 255)',
        ':host(:not()) styles are applied (backgroundColor)');

      var scope = document.querySelector('x-scope');
      chai.assert.equal(getComputedStyle(scope).backgroundColor, 'rgb(255, 0, 0)',
        ':host styles matching :scope  are applied (backgroundColor)');

      var scope2 = document.querySelector('x-scope.foo');
      chai.assert.equal(getComputedStyle(scope2).backgroundColor, 'rgb(0, 0, 0)',
        ':host styles matching :scope are conditionally applied (backgroundColor)');

      var bar = document.querySelector('x-bar');
      var barStyle = getComputedStyle(bar);
      chai.assert.equal(barStyle.backgroundColor, 'rgb(255, 0, 0)',
        ':host styles are inherited (backgroundColor)');
      chai.assert.equal(barStyle.color, 'rgb(255, 255, 255)',
        ':host styles are combined with inherited :host styles (color)');

      var bar2 = document.querySelector('x-bar2');
      var bar2Style = getComputedStyle(bar2);
      chai.assert.equal(bar2Style.backgroundColor, 'rgb(255, 0, 0)',
        ':host styles are inherited (backgroundColor)');

      var zot = document.querySelector('x-zot');
      var zotStyle = getComputedStyle(zot);
      chai.assert.equal(zotStyle.backgroundColor, 'rgb(255, 0, 0)',
        ':host styles are inherited (backgroundColor)');
      chai.assert.equal(zotStyle.borderTopColor, 'rgb(255, 165, 0)',
        ':host styles are combined with inherited :host styles (borderTopColor)');
      chai.assert.equal(zotStyle.color, 'rgb(255, 255, 255)',
        ':host styles are applied to given selector (color)');

      var zim = document.querySelector('x-zim');
      var zimStyle = getComputedStyle(zim);
      chai.assert.equal(zimStyle.backgroundColor, 'rgb(255, 0, 0)',
        ':host styles are inherited (backgroundColor)');

      chai.assert.equal(zimStyle.borderTopColor, 'rgb(165, 42, 42)',
        ':host styles are combined with inherited :host styles (borderTopColor)');
      chai.assert.equal(zimStyle.borderBottomColor, 'rgb(255, 165, 0)',
        ':host styles are combined with inherited :host styles (borderBottomColor)');
      chai.assert.equal(zimStyle.color, 'rgb(255, 255, 255)',
        ':host styles are applied to given selector (color)');
      chai.assert.equal(zimStyle.paddingTop, '20px',
        ':host styles are loaded via external sheet in import (paddingTop)');
      chai.assert.equal(zimStyle.paddingLeft, '20px',
        ':host styles are loaded via external sheet in import (paddingLeft)');
      zim.offsetHeight;

      var zim2 = document.querySelector('x-zim2');
      var zimStyle2 = getComputedStyle(zim2);
      chai.assert.equal(zimStyle2.borderTopColor, 'rgb(255, 165, 0)',
        ':host styles are combined without <shadow> (borderTopColor)');
      chai.assert.equal(zimStyle2.borderBottomColor, 'rgb(255, 165, 0)',
        ':host styles are combined without <shadow> (borderBottomColor)');
      chai.assert.equal(zimStyle2.paddingTop, '20px',
        ':host styles are loaded via external sheet in import (paddingTop)');
      chai.assert.equal(zimStyle2.paddingLeft, '20px',
        ':host styles are loaded via external sheet in import (paddingLeft)');

      chai.assert.equal(zimStyle2.backgroundColor, 'rgb(0, 128, 0)',
        ':host(.foo:host) styles are applied (backgroundColor)');

      var zim2_2 = document.querySelector('.bar > x-zim2');
      var zimStyle2_2 = getComputedStyle(zim2_2);
      chai.assert.equal(zimStyle2_2.backgroundColor, 'rgb(0, 128, 0)',
        ':host(.foo:host) styles are applied (backgroundColor)');

      var zim2_3 = document.querySelector('.foo > x-zim2');
      var zimStyle2_3 = getComputedStyle(zim2_3);
      chai.assert.notEqual(zimStyle2_3.backgroundColor, 'rgb(0, 128, 0)',
        ':host(.foo:host) styles are not applied when host doesn\'t contain .foo (backgroundColor)');

      var btn = document.querySelector('[is=x-button]');
      var btnStyle = getComputedStyle(btn);
      chai.assert.equal(btnStyle.backgroundColor, 'rgb(0, 128, 0)',
        ':host styles are shimmed for type extension (backgroundColor)');

      var a = document.querySelector('[is=x-anchor]');
      a.dispatchEvent(new MouseEvent('click', {
        'view': window,
        'bubbles': true,
        'cancelable': true
      }));
      var aStyle = getComputedStyle(a);
      chai.assert.equal(aStyle.fontStyle, 'italic',
        ':host:pseudoclass styles are shimmed (font-style)');

      done();
    });
  