
  suite('WeakMap', function() {
    var assert = chai.assert;

    test('WeakMap has get, set, delete, and has functions', function() {
      assert.isDefined(WeakMap.prototype.get);
      assert.isDefined(WeakMap.prototype.set);
      assert.isDefined(WeakMap.prototype.delete);
      assert.isDefined(WeakMap.prototype.has);
    });

    test('WeakMap\'s methods perform as expected', function() {
      var wm = new WeakMap();

      var o1 = {};
      var o2 = function(){};
      var o3 = window;

      wm.set(o1, 37).set(o2, 'aoeui');

      assert.equal(wm.get(o1), 37);
      assert.equal(wm.get(o2), 'aoeui');

      wm.set(o1, o2);
      wm.set(o3, undefined);

      assert.deepEqual(wm.get(o1), o2);
      // `wm.get({})` should return undefined, because there is no value for
      // the object on wm
      assert.equal(wm.get({}), undefined);
      // `wm.get(o3)` should return undefined, because that is the set value
      assert.equal(wm.get(o3), undefined);

      assert.equal(wm.has(o1), true);
      assert.equal(wm.has({}), false);

      wm.delete(o1);
      assert.equal(wm.get(o1), undefined);
      assert.equal(wm.has(o1), false);
      // Ensure that delete returns true/false indicating if the value was removed
      assert.equal(wm.delete(o2), true);
      assert.equal(wm.delete({}), false);
    });
  });
