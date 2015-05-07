
      addEventListener('HTMLImportsLoaded', function() {
        // test setup: mock xhr.
        var origXHR = window.XMLHttpRequest;
        var XHRCount = 0;
        window.XMLHttpRequest = function() {
          XHRCount++;
          return new origXHR();
        };

        var assert = chai.assert;
        var loader = new Polymer.Loader(/import: ([^;]*)/g);
        var test = document.querySelector('#test');
        loader.process(test.textContent, document.baseURI, function(map) {
          assert.equal(XHRCount, 1);
          done();
        });
      });
    