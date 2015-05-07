
    register('x-foo', '', HTMLElement.prototype);
    register('x-button', 'button', HTMLButtonElement.prototype, ['x-button']);

    document.addEventListener('WebComponentsReady', function() {
      setTimeout(function() {
        var foo = document.querySelector('x-foo');
        var fooDiv = foo.shadowRoot.querySelector('div');
        var fooDivStyle = getComputedStyle(fooDiv);
        chai.assert.equal(fooDivStyle.fontSize, window.innerWidth < 800 ? '50px' : '20px',
          'shadowDOM styles are applied');
        var fooDivBeforeStyle = getComputedStyle(fooDiv, ':before');
        chai.assert.equal(fooDivBeforeStyle.backgroundColor, 'rgb(0, 0, 255)',
          ':before styles are applied');

        var xButtonDiv = document.querySelector('[is=x-button]')
            .shadowRoot.querySelector('div');
        var xButtonDivStyle = getComputedStyle(xButtonDiv);
        chai.assert.equal(xButtonDivStyle.backgroundColor, 'rgb(255, 0, 0)',
          'type extension is properly shimmed');
        chai.assert.equal(xButtonDivStyle.fontSize, '50px',
          'media query for type extension is properly shimmed');

        done();
      });
    });
  