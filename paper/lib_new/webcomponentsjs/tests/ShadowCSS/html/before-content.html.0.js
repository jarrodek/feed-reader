
    register('x-test', '', HTMLElement.prototype);

    document.addEventListener('WebComponentsReady', function() {
      setTimeout(function() {
        var root = document.querySelector('x-test').shadowRoot;
        function testContent(node, contentRe) {
          chai.assert.match(getComputedStyle(node, ':before').content, contentRe, 'content ' +
              'property set correctly.');
        }
        testContent(root.querySelector('#one'), new RegExp('hithere'));
        testContent(root.querySelector('#two'), new RegExp('hithere '));
        testContent(root.querySelector('#three'), new RegExp(' hithere'));
        testContent(root.querySelector('#four'), new RegExp('hi there'));
        testContent(root.querySelector('#five'), new RegExp('7|attr\\(test\\)'));
        done();
      });
    });
  