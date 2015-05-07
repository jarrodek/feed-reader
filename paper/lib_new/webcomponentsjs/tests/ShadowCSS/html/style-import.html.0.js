
      document.addEventListener('WebComponentsReady', function() {
        function getComputed(selector) {
          return getComputedStyle(document.querySelector(selector));
        }

        chai.assert.equal(getComputed('#test1').backgroundColor, 'rgb(255, 0, 0)', 'shimmed imported style is loaded');
        chai.assert.equal(getComputed('#test2').backgroundColor, 'rgb(0, 0, 255)', 'shimmed imported sheet is loaded');
        chai.assert.ok(getComputed('#test3').backgroundImage, 'shimmed imported style path is correct');
        done();
      });
    