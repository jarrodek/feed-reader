
      Polymer('x-test', {
        foo: '',
        forceReady: true,
        ready: function() {},
        fooChanged: function() {
          this.fooWasChanged = true;
        },
        barChanged: function() {
          this.validBar = this.bar;
        },
        isBarValid: function() {
          return this.validBar == this.bar;
        }
      });
    