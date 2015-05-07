
      Polymer('x-test', {
        tests: 0,
        parseDeclaration: function(elementElement) {
          var template = this.fetchTemplate(elementElement);
          if (template) {
            this.lightFromTemplate(template);
          }
        },
        ready: function() {
          this.list1 = [];
          this.list2 = [];
          var self = this;
          for (var i=0, o; i <10; i++) {
            o = {index: i, itemTapAction: function(e) {
              //console.log('model action: [%s].%s', e.currentTarget.localName, e.type, this);
              self.itemTapAction(e);
            }};
            this.list1.push(o);
            this.list2.push(o);
          }
          this.runTests();
        },
        foo: {
          // called in element context
          itemTapAction: function(e) {
            this.itemTapAction(e);
          }
        },
        hostTapAction: function(e) {
          this.logEvent(e);
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
          this.tests++;
          this.lastEvent = e.type;
          //console.log('[%s].%s: %s', e.currentTarget.localName, e.type, message || '');
        },
        itemTapAction: function(e) {
          var model = e.target.templateInstance.model;
          this.logEvent(e, 'item: ' + (model.item ? model.item.index : model.index));
          e.stopPropagation();
        },
        runTests: function() {
          this.fire('tap', null, this.$.div, true);
          chai.assert.equal(this.tests, 2, 'event heard at div and host');
          chai.assert.equal(this.lastEvent, 'tap', 'tap handled');
          this.fire('focus', null, this.$.input, false);
          chai.assert.equal(this.tests, 3, 'event heard by input');
          chai.assert.equal(this.lastEvent, 'focus', 'focus handled');
          this.fire('blur', null, this.$.input, false);
          chai.assert.equal(this.tests, 4, 'event heard by input');
          chai.assert.equal(this.lastEvent, 'blur', 'blur handled');
          this.fire('scroll', null, this.$.list, false);
          chai.assert.equal(this.tests, 5, 'event heard by list');
          chai.assert.equal(this.lastEvent, 'scroll', 'scroll handled');
          this.onMutation(this.$.list, function() {
            var l1 = this.$.list.querySelector('.list1');
            this.fire('tap', null, l1, false);
            chai.assert.equal(this.tests, 6, 'event heard by list1 item');
            chai.assert.equal(this.lastEvent, 'tap', 'tap handled');
            var l2 = this.$.list.querySelector('.list2');
            this.fire('tap', null, l2, false);
            chai.assert.equal(this.tests, 7, 'event heard by list2 item');
            chai.assert.equal(this.lastEvent, 'tap', 'tap handled by model');
            done();
          });
        }
      });
    