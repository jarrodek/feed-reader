
        Polymer('x-foo', {
          asyncCount: 0,
          totalAsyncs: 5,
          ready: function() {
            var c = 0, d, e;
            for (var i=0; i < this.totalAsyncs; i++) {
              this.cancelAsync(this.async('asyncHandler'));
              this.cancelAsync(this.async('asyncHandler', null, 1));
            }
            this.async('done');
          },
          asyncHandler: function() {
            this.asyncCount++;
          },
          done: function() {
            this.async('test', null, 50);
          },
          test: function() {
            chai.assert.equal(this.asyncCount, 0);
            done();
          }
        });
      