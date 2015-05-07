
    document.addEventListener('polymer-ready', function() {
      
      var xother = document.querySelector('x-other');
      
      function test(node, propertyName, value) {
        var computed = getComputedStyle(node)[propertyName];
        chai.assert.equal(computed, value, 'computed ' + propertyName + 
            ' matches expected.');
      }
      var node1 = document.querySelector('#node1');
      var node2 = document.querySelector('#node2');
      var node3 = document.querySelector('#node3');

      test(node1, 'backgroundColor', 'rgb(255, 0, 0)');
      test(node1, 'fontStyle', 'italic');
      test(node2, 'backgroundColor', 'rgb(0, 0, 255)');
      test(node2, 'fontStyle', 'italic');
      test(node3, 'backgroundColor', 'rgb(255, 255, 0)');
      test(node4, 'backgroundColor', 'rgb(255, 0, 0)');
      test(xother.$.inner1, 'backgroundColor', 'rgb(0, 0, 255)');
      test(xother.$.inner1, 'fontStyle', 'italic');
      test(xother.$.inner2, 'backgroundColor', 'rgb(255, 255, 0)');

      // de-duping styles.
      if (window.ShadowDOMPolyfill) {
        chai.assert.equal(document.head.querySelectorAll('style[element=x-stylish-controller]').length, 2, 'styles are properly de-duped');
      } else {
        chai.assert.equal(document.head.querySelectorAll('style[element=x-stylish-controller').length, 1, 'styles are properly de-duped');
        chai.assert.equal(xother.shadowRoot.querySelectorAll('style[element=x-stylish-controller').length, 1, 'styles are properly de-duped');
      }
      done();
    });
  