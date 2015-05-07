
      document.addEventListener('DOMContentLoaded', function() {
        // some time later
        setTimeout(function() {
          var div = document.createElement('div');
          div.innerHTML = '<link rel="import" href="imports/load-1.html">' +
              '<link rel="import" href="imports/load-2.html">';
          document.body.appendChild(div);
          var ports = document.querySelectorAll('link[rel=import]');
          var loads = 0;
          for (var i=0, l=ports.length, n; (i<l) && (n=ports[i]); i++) {
            n.addEventListener('load', function(e) {
              loads++;
              chai.assert.ok(e.target.import);
            });
          }
          HTMLImports.whenReady(function() {
            chai.assert.equal(loads, 2);
            done();
          });
        });
      });
    