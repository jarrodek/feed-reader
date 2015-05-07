
    var assert = chai.assert;
    function assertStyle(node, style, equals) {
      assert.equal(getComputedStyle(node).getPropertyValue(style), equals);
    }
    var target = document.querySelector('#target');
    var style = document.querySelector('#flatten');
    var transformRule = typeof target.style.transform === 'string' ? 'transform' : '-webkit-transform';

    function runTests(target) {
      assertStyle(target, 'background-color', 'rgb(0, 128, 0)');
      assertStyle(target.firstElementChild, 'color', 'rgb(255, 165, 0)');
      assertStyle(target, 'height', '100px');
      assertStyle(target, 'width', '100px');
      assertStyle(target, transformRule, 'matrix(1, 0, 0, 1, 50, 50)');
      assertStyle(target, 'border-top-width', '2px');
      assertStyle(target, 'border-left-color', 'rgb(128, 128, 128)');
      assertStyle(target, 'border-bottom-style', 'solid');
    }

    function evaluateStyles() {
      var cssRules = style.sheet.cssRules;
      assert.equal(cssRules.length, 3);
      for (var i = 0; i < cssRules.length; i++) {
        assert.instanceOf(cssRules[i], window.CSSImportRule);
      }
      runTests(target);

      // flatten the @import rules and test again
      Polymer.styleResolver.loadStyles([style], style.ownerDocument.baseURI, function() {
        var cssRules = style.sheet.cssRules;
        assert.equal(cssRules.length, 6);
        for(var i = 0; i < cssRules.length; i++) {
          assert.instanceOf(cssRules[i], window.CSSStyleRule);
        }
        runTests(target);
        assert.equal(Polymer.styleResolver.loader.requests, 10, 'Number of stylesheet requests were not expected');
      });
    }

    addEventListener('WebComponentsReady', function() {
      if (style.sheet && style.sheet.cssRules) {
        evaluateStyles();
      } else {
        style.addEventListener('load', function() {
          evaluateStyles();
        });
        style.addEventListener('error', assert.fail);
      }
      document.body.appendChild(document.createElement('custom-style'));
    });

    addEventListener('custom-style-loaded', function() {
      var shadowTarget = document.querySelector('custom-style').shadowRoot.querySelector('#target');
      runTests(shadowTarget);
      done();
    });
  