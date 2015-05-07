
    function testCreated(name) {
      var e = document.querySelector(name);
      chai.assert.isTrue(Polymer.instanceOfType(e, name));
    }

    addEventListener('HTMLImportsLoaded', function() {
      setTimeout(function() {
        // test waitingFor
        var elements = Polymer.waitingFor();
        chai.assert.equal(elements.length, 2);
        chai.assert.equal(elements[0].name, 'x-bar');
        chai.assert.equal(elements[1].name, 'x-baz');
        // test forceReady
        Polymer.forceReady();
      }, 50);
    });
    addEventListener('polymer-ready', function() {
      var elements = Polymer.waitingFor();
      chai.assert.equal(elements.length, 2);
      chai.assert.equal(elements[0].name, 'x-bar');
      chai.assert.equal(elements[1].name, 'x-baz');
      Polymer.whenReady(function() {
        chai.assert.equal(Polymer.waitingFor(), 0);
        testCreated('x-foo');
        testCreated('x-bar');
        testCreated('x-baz');
        //
        // dynamic creation
        var p = document.createElement('polymer-element');
        p.setAttribute('name', 'x-zot');
        p.init();
        var elements = Polymer.waitingFor();
        chai.assert.equal(elements.length, 1);
        chai.assert.equal(elements[0].name, 'x-zot');
        //
        // forceReady delayed
        Polymer.forceReady(50);
        Polymer.whenReady(function() {
          var elements = Polymer.waitingFor();
          chai.assert.equal(elements.length, 1);
          chai.assert.equal(elements[0].name, 'x-zot');
          Polymer('x-zot');
          Polymer.whenReady(function() {
            testCreated('x-zot');
            done();
          });
        });
      });
      // test registering after forceReady
      Polymer('x-bar');
      Polymer('x-baz');
    });
  