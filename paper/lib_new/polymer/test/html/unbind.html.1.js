
     function testAsync(tests, delay, args) {
       if (tests.length) {
         CustomElements.takeRecords();
         setTimeout(function() {
           var lastArgs = tests.shift().apply(null, args || []);
           testAsync(tests, delay, lastArgs);
         }, delay);
       } else {
         done();
       }
     }

    document.addEventListener('polymer-ready', function() {
      xTest = document.querySelector('x-test');
      xTest.foo = 'bar';
      Platform.flush();

      function assertNoObservers() {
        chai.assert.equal(Observer._allObserversCount, 0);
      }

      function assertSomeObservers() {
        chai.assert.isTrue(Observer._allObserversCount > 0);
      }

      testAsync([
        function() {
          chai.assert.ok(!xTest._unbound,
            'element is bound when inserted');
          chai.assert.isTrue(xTest.fooWasChanged,
            'element is actually bound');
          assertSomeObservers();
          xTest.parentNode.removeChild(xTest);
        },
        function() {
          chai.assert.isTrue(xTest._unbound,
            'element is unbound when removed');
          assertNoObservers();
          return [document.createElement('x-test')];
        },
        function(node) {
          chai.assert.isUndefined(node._unbound,
            'element is bound when not inserted');
          node.foo = 'bar';
          assertSomeObservers();
          Platform.flush();
          return [node];
        },
        function(node) {
          chai.assert.isTrue(node.fooWasChanged, 'node is actually bound');
          node.unbindAll();
          var n = document.createElement('x-test');
          document.body.appendChild(n);
          return [n];
        },
        function(node) {
          node.preventDispose = true;
          node.parentNode.removeChild(node);
          return [node];
        },
        function(node) {
          chai.assert.ok(!node._unbound,
            'element is bound when preventDispose is true');
          assertSomeObservers();
          node.unbindAll();
          chai.assert.isTrue(node._unbound,
            'element is unbound when unbindAll is called');
          assertNoObservers();
          var n = document.createElement('x-test');
          document.body.appendChild(n);
          return [n];
        },
        function(node) {
          chai.assert.ok(!node._unbound,
            'element is bound when manually inserted');
          assertSomeObservers();
          document.body.removeChild(node);
          return [node];
        },
        function(node) {
          chai.assert.isTrue(node._unbound,
            'element is unbound when manually removed is called');
          assertNoObservers();
        }
      // TODO(sorvell): In IE, the unbind time is indeterminate, so wait an
      // extra beat.
      ], 50);
    });
  