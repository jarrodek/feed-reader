
      Polymer('x-test', {
        one: 'tomato',
        two: 'steelblue',
        three: 'whitesmoke',
        four: 'tomato',
        five: 'steelblue',
        six: 'whitesmoke',
        seven: 'tomato',
        eight: 'steelblue',
        nine: 'whitesmoke',
        ten: 'tomato',
        oneChanged: function() {
          console.log('oneChanged', this.one);
          this.asyncUnbindAll();
        },
        twoChanged: function() {
        },
        threeChanged: function() {
        },
        fourChanged: function() {
        },
        fiveChanged: function() {
        },
        sixChanged: function() {
        },
        sevenChanged: function() {
        },
        eightChanged: function() {
        },
        nineChanged: function() {
        },
        tenChanged: function() {
        }
      });
    