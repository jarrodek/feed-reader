
    addEventListener('polymer-ready', function() {
      var assert = chai.assert;
      var foo = document.querySelector('x-foo');
      assert.equal(foo.squid, 'ink');
      var bar = document.querySelector('x-bar');
      assert.equal(bar.squid, 'ink');
      var zot = document.querySelector('x-zot');
      assert.ok(zot.shadowRoot);
      var zap = document.querySelector('x-zap');
      assert.ok(zap.shadowRoot);
      var fizz = document.querySelector('x-fizz');
      assert.equal(fizz.squid, 'fink');
      var zzif = document.querySelector('x-zzif');
      assert.equal(zzif.squid, 'zink');
      var myLi = document.querySelector('[is=my-li]');
      assert.equal(myLi.custom, true);
      var mySubLi = document.querySelector('[is=my-sub-li]');
      assert.equal(mySubLi.custom, true);

      // dynamic element creation.
      var pe = document.createElement('polymer-element');
      pe.setAttribute('name', 'x-dynamic');
      pe.init();
      Polymer('x-dynamic', {
        dynamic: true
      });

      // re-registration throws
      assert.throws(function() { Polymer('x-dynamic'); });
      var dynamic = document.createElement('x-dynamic');
      assert.equal(dynamic.dynamic, true);

      done();
    });
  