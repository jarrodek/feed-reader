
      var template = document.getElementById('one');
      
      template.greeting = 'Hi';
      
      template.eventAction = function(e) {
        e.handled = true;
      }

      template.test = function() {
        var h = this.$.h;
        chai.assert.equal(h.textContent, this.greeting, 'binding applied');
        var e = this.fire('tap', {}, h);
        chai.assert.isTrue(e.handled, 'element event handler fired');
      }

      var events = 0;

      addEventListener('template-bound', function(e) {
        events++;
        if (e.target.id === 'one') {
          e.target.test();
        }

        if (events === 3) {
          done();
        }

      });

      // test dynamic creation
      addEventListener('polymer-ready', function() {
        var d = document.createElement('div');
        d.innerHTML ='<template is="auto-binding">Dynamical <input value="{{value}}"><div>{{value}}</div></template>';
        document.body.appendChild(d);
      });

    