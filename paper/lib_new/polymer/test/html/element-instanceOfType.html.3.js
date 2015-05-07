
      addEventListener('HTMLImportsLoaded', function() {
        setTimeout(function() {
          Polymer('x-blarg', {
            ready: function() {
              this.squid = 'bink';
            }
          });
        });
      });
    