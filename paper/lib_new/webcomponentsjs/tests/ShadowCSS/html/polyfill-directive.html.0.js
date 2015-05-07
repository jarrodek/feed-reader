
    XFoo = register('x-foo', '', HTMLElement.prototype);
    XBar = register('x-bar', 'x-foo', HTMLElement.prototype);
    XAuto = register('x-auto', '', HTMLElement.prototype);

    document.addEventListener('WebComponentsReady', function() {
      setTimeout(function() {
        // x-foo
        var n = document.querySelector('x-foo');
        var fooStyle = getComputedStyle(n);
        chai.assert.equal(fooStyle.paddingTop, '10px', 'host attribute style correct');
        var divStyle = getComputedStyle(n.firstElementChild);
        chai.assert.equal(divStyle.backgroundColor,
          'rgb(0, 128, 0)', 'single quote polyfill-next-selector');
        chai.assert.equal(divStyle.color,
          'rgb(255, 0, 0)', '@polyfill');
        var sectionStyle = getComputedStyle(n.lastElementChild);
        chai.assert.equal(sectionStyle.backgroundColor,
          'rgb(255, 165, 0)', 'double quote polyfill-next-selector');
        chai.assert.equal(sectionStyle.paddingTop,
          '10px', 'double quote polyfill-next-selector');
        chai.assert.equal(sectionStyle.color,
          'rgb(255, 0, 0)', '@polyfill');
        //
        // x-bar
        var n = document.querySelector('x-bar');
        var divStyle = getComputedStyle(n.firstElementChild);
        chai.assert.equal(divStyle.backgroundColor,
          'rgb(0, 128, 0)', 'extended single quote polyfill-next-selector');
        chai.assert.equal(divStyle.color,
          'rgb(255, 0, 0)', '@polyfill');
        var sectionStyle = getComputedStyle(n.lastElementChild);
        chai.assert.equal(sectionStyle.backgroundColor,
          'rgb(255, 165, 0)', 'extended double quote polyfill-next-selector');
        chai.assert.equal(sectionStyle.color,
          'rgb(255, 0, 0)', '@polyfill');
        //
        var auto = document.querySelector('x-auto');
        chai.assert.equal(getComputedStyle(auto.firstElementChild).backgroundColor,
        'rgb(0, 128, 0)', 'auto-replaced ::content');
        chai.assert.equal(getComputedStyle(auto.lastElementChild).backgroundColor,
        'rgb(255, 0, 0)', 'auto-replaced ::content');
        done();
      });
    });
  