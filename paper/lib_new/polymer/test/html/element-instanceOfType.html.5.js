
    addEventListener('polymer-ready', function() {
      var assert = chai.assert;
      var foo = document.querySelector('x-foo');
      assert.isTrue(Polymer.instanceOfType(foo, 'x-foo'));
      //      
      var bar = document.querySelector('x-bar');
      assert.isTrue(Polymer.instanceOfType(bar, 'x-bar'));
      assert.isTrue(Polymer.instanceOfType(bar, 'x-foo'));
      //
      var zot = document.querySelector('x-zot');
      assert.isTrue(Polymer.instanceOfType(zot, 'x-zot'));
      assert.isFalse(Polymer.instanceOfType(zot, 'x-foo'));
      //
      var zap = document.querySelector('x-zap');
      assert.isTrue(Polymer.instanceOfType(zap, 'x-zap'));
      assert.isTrue(Polymer.instanceOfType(zap, 'x-zot'));
      //i
      var fizz = document.querySelector('x-fizz');
      assert.isTrue(Polymer.instanceOfType(fizz, 'x-fizz'));
      assert.isTrue(Polymer.instanceOfType(fizz, 'x-zap'));
      assert.isTrue(Polymer.instanceOfType(fizz, 'x-zot'));
      //
      var zzif = document.querySelector('x-zzif');
      assert.isTrue(Polymer.instanceOfType(zzif, 'x-zzif'));
      assert.isTrue(Polymer.instanceOfType(zzif, 'x-zap'));
      assert.isTrue(Polymer.instanceOfType(zzif, 'x-zot'));
      assert.isFalse(Polymer.instanceOfType(zzif, 'x-fizz'));
      //
      var myLi = document.querySelector('[is=my-li]');
      assert.isTrue(Polymer.instanceOfType(myLi, 'my-li'));
      //
      var mySubLi = document.querySelector('[is=my-sub-li]');
      assert.isTrue(Polymer.instanceOfType(mySubLi, 'my-sub-li'));
      assert.isTrue(Polymer.instanceOfType(mySubLi, 'my-li'));
      done();
    });
  