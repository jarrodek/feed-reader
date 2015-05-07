
      var t = document.querySelector('template');
      t.addEventListener('template-bound', function() {
        if (Observer.hasObjectObserve) {
          t.model.value = 'test skipped due to Object.observe';
          done();
        } else {
          t.model.value = 'a';
          var s = document.querySelector('span');
          var a = document.querySelector('a');
          document.addEventListener('visibilitychange', function(){
            console.log('visibility change!');
          });
          window.addEventListener('message', function(ev) {
            if (ev.data === 'popup-initialized') {
              console.log('got popup initialized');
              t.model.value = 'b';
              setTimeout(function() {
                chai.assert.equal(document.hidden, true);
                chai.assert.equal(s.textContent, 'a', 'change did not occur, and shouldn\'t');
                console.log('send close');
                ev.source.postMessage('close', location.origin);
              }, 300);
            }
            if (ev.data === 'popup-closed') {
              setTimeout(function() {
                chai.assert.equal(s.textContent, 'b', 'change did occur, and should');
                done();
              }, 300);
            }
          });
        }
      });
    