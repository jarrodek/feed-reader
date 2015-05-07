
      var assert = chai.assert;
      document.addEventListener('polymer-ready', function() {
        assert.isTrue(document.querySelector("#foo0").bool);
        assert.isFalse(document.querySelector("#foo1").bool);
        assert.isTrue(document.querySelector("#foo2").bool);
        assert.isFalse(document.querySelector("#foo3").bool);
        // this one is only 'truthy'
        assert.ok(document.querySelector("#foo4").bool);
        // this one is also 'truthy', but should it be?
        assert.ok(document.querySelector("#foo5").bool);
        //
        assert.equal(document.querySelector("#foo0").num, 42);
        assert.equal(document.querySelector("#foo0").str, "don't panic");
        //
        assert.isTrue(document.querySelector("#bar0").bool);
        assert.isFalse(document.querySelector("#bar1").bool);
        assert.isTrue(document.querySelector("#bar2").bool);
        assert.isFalse(document.querySelector("#bar3").bool);
        // this one is only 'truthy'
        assert.ok(document.querySelector("#bar4").bool);
        // this one is also 'truthy', but should it be?
        assert.ok(document.querySelector("#bar5").bool);
        //
        assert.equal(document.querySelector("#bar0").num, 42);
        assert.equal(document.querySelector("#bar0").str, "don't panic");
        //
        assert.isTrue(document.querySelector("#zot0").bool);
        assert.isFalse(document.querySelector("#zot1").bool);
        assert.isTrue(document.querySelector("#zot2").bool);
        assert.isFalse(document.querySelector("#zot3").bool);
        // this one is only 'truthy'
        assert.ok(document.querySelector("#zot4").bool);
        // this one is also 'truthy', but should it be?
        assert.ok(document.querySelector("#zot5").bool);
        //
        assert.equal(document.querySelector("#zot0").num, 84);
        assert.equal(document.querySelector("#zot6").num, 185);
        assert.equal(document.querySelector("#zot0").str, "don't panic");
        // 
        // Date deserialization tests
        assert.equal(String(document.querySelector("#date1").value), String(new Date(2014, 11, 25)));
        assert.equal(String(document.querySelector("#date2").value), String(new Date(2014, 11, 25)));
        assert.equal(String(document.querySelector("#date3").value), String(new Date(2014, 11, 25, 11, 45)));
        assert.equal(String(document.querySelector("#date4").value), String(new Date(2014, 11, 25, 11, 45, 30)));
        // Failures on Firefox. Need to fix this with custom parsing
        //assert.equal(String(document.querySelector("#date5").value), String(new Date(2014, 11, 25, 11, 45, 30)));
        //
        // milliseconds in the Date string not supported on Firefox
        //assert.equal(document.querySelector("#date5").value.getMilliseconds(), new Date(2014, 11, 25, 11, 45, 30, 33).getMilliseconds());
        //
        // Array deserialization tests
        assert.deepEqual(document.querySelector("#arr1").values, [0, 1, 2]);
        assert.deepEqual(document.querySelector("#arr2").values, [33]);
        // Object deserialization tests
        assert.deepEqual(document.querySelector("#obj1").values, { name: 'Brandon', nums: [1, 22, 33] });
        assert.deepEqual(document.querySelector("#obj2").values, { "color": "Red" });
        assert.deepEqual(document.querySelector("#obj3").values, { movie: 'Buckaroo Banzai', DOB: '07/31/1978' });
        //
        // Comma test
        assert.isTrue(document.querySelector('#comma1').bool);
        assert.isFalse(document.querySelector('#comma2').bool);
        assert.isTrue(document.querySelector('#comma3').bool);
        assert.equal(document.querySelector('#comma4').num, 1);
        assert.equal(document.querySelector('#comma5').str, 'hi');
        //
        // Vertical Space test
        assert.isTrue(document.querySelector('#vertspace1').bool);
        assert.isFalse(document.querySelector('#vertspace2').bool);
        assert.isTrue(document.querySelector('#vertspace3').bool);
        assert.equal(document.querySelector('#vertspace4').num, 1);
        assert.equal(document.querySelector('#vertspace5').str, 'hi');
        done();
      });
    