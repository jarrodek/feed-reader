
        Polymer('x-foo', {
          computed: {
            concat: "a + b",
            upper: "toUpperCase(concat)",
          },
          toUpperCase: function(str) {
            return str.toUpperCase();
          }
        })
      