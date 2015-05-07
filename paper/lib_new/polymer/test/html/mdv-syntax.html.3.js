
      Polymer('mdv-holder', {
        runTests: function() {
          this.$.bind.runTests();
          this.$.repeat.runTests();
          this.$.math.runTests();
        },
        ready: function() {
          this.onMutation(this.$.math, function() {
            this.runTests();
            done();
          });
        }
      });
    