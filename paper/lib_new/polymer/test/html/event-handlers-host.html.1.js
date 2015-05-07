
      Polymer('x-test', {
        eventDelegates: {
          pointerdown: 'testPointerDownAction',
        },
        ready: function() {
          var e = this.fire('tap', {}, this.$.test);
          chai.assert.equal(e.tapped, 2, 'instance and host event listener can co-exist');
          var e2 = this.fire('pointerdown', {}, this);
          chai.assert.isTrue(e2.touched, 'eventDelegates works');
          done();
        },
        testTapAction: function(e) {
          e.tapped++;
        },
        testPointerDownAction: function(e) {
          e.touched = true;
        }
      });
    