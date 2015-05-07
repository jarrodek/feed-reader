
    
    document.addEventListener('polymer-ready', function() {

      function checkResolved(node) {
        chai.assert.isFalse(node.hasAttribute('unresolved'), 'element does not have unresolved attribute');
      }

      checkResolved(document.body);

      Array.prototype.forEach.call(document.querySelectorAll('x-test'), function(t) {
        checkResolved(t);
      });

      chai.assert.isTrue(document.querySelector('x-foo').hasAttribute('unresolved'), 'unresolved exists on un-upgraded element');

      done();
    });
  