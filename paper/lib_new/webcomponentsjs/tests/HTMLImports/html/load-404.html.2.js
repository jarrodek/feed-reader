
      var loaded = false;
      addEventListener('HTMLImportsLoaded', function() {
        loaded = true;
        check();
      });

      // wait some time and then fail if no load event is fired
      var timeout = setTimeout(function() {
        check();
      }, 2000);

      function check() {
        clearTimeout(timeout);
        chai.assert.ok(loaded, '404\'d imports are loaded');
        chai.assert.equal(document.querySelector('link').import, null, '404\'d link.import is null');
        chai.assert.equal(errors, 2, '404\'d generate error event');
        done();
      }
    