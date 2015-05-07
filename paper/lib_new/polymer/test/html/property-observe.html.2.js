
        (function() {
          Polymer('x-test2', {
            bar: '',
            observe: {
              noogle: 'validate'
            },
            ready: function() {
              this.super();
              this.noogle = 'noogle'
            }
          });
        })();
      