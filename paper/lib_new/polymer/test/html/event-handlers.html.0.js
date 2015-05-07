
      Polymer('x-test', {
        tests: 0,
        ready: function() {
          this.list1 = [];
          this.list2 = [];
          for (var i=0, o; i <10; i++) {
            o = {index: i};
            this.list1.push(o);
          }
          for (var i=0, o; i <10; i++) {
            o = {index: i, itemTapAction: function(e) {
              this.itemTapAction(e);
            }};
            this.list2.push(o);
          }
          this.runTests();
        },
        hostTapAction: function(e) {
          e.gotHostEvent = true;
        },
        divTapAction: function(e) {
          this.logEvent(e);
        },
        focusAction: function(e) {
          this.logEvent(e);
        },
        blurAction: function(e) {
          this.logEvent(e);
        },
        scrollAction: function(e) {
          this.logEvent(e);
        },
        logEvent: function(e, message) {
          e.gotEvent = true;
          //console.log('[%s].%s: %s', e.currentTarget.localName, e.type, message || '');
        },
        itemTapAction: function(e) {
          var model = e.target.templateInstance.model;
          this.logEvent(e, 'item: ' + (model.item ? model.item.index : model.index));
          e.stopPropagation();
        },
        itemUpAction: function(e) {
          this.logEvent(e);
        },
        runTests: function() {
          var e = this.fire('tap', null, this.$.div, true);
          chai.assert.isTrue(e.gotEvent, 'tap event heard at div host');
          chai.assert.isTrue(e.gotHostEvent, 'tap event heard at host');
          e = this.fire('focus', null, this.$.input, false);
          chai.assert.isTrue(e.gotEvent, 'focus event heard by input');
          e = this.fire('blur', null, this.$.input, false);
          chai.assert.isTrue(e.gotEvent, 'blur event heard by input');
          e = this.fire('scroll', null, this.$.list, false);
          chai.assert.isTrue(e.gotEvent, 'scroll event heard by list');
          this.onMutation(this.$.list, function() {
            var l1 = this.$.list.querySelector('.list1');
            var e = this.fire('up', null, l1, false);
            var l2 = this.$.list.querySelector('.list2');
            e = this.fire('tap', null, l2, false);
            chai.assert.isTrue(e.gotEvent, 'tap event heard by list2 item');
            done();
          });
        }
      });
    