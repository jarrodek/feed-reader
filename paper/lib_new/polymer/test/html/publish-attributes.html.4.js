
      var assert = chai.assert;
      document.addEventListener('polymer-ready', function() {
        
        // tests publishAttributes
        
        assert.deepEqual(
            XFoo.prototype.publish, 
            {Foo: undefined, baz: undefined}, 1);
        assert.deepEqual(
            XBar.prototype.publish, 
            {Foo: undefined, baz: undefined, Bar: undefined}, 2);
        assert.deepEqual(
            XZot.prototype.publish, 
            {Foo: undefined, baz: undefined, Bar: undefined, zot: 3}, 3);
        assert.deepEqual(
            XSquid.prototype.publish, 
            {Foo: undefined, baz: 13, Bar: undefined, zot: 5, squid: 7}, 4);

        // tests publishProperties
            
        assert.equal(XSquid.prototype.Foo, null);
        assert.equal(XSquid.prototype.baz, 13);
        assert.equal(XSquid.prototype.Bar, null);
        assert.equal(XSquid.prototype.zot, 5);
        assert.equal(XSquid.prototype.squid, 7);

        done();
      });
    