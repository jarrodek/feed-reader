
      addEventListener('HTMLImportsLoaded', function() {
        var eventName = 'some-event';
        var eventDetail = 'some-detail';

        document.body.addEventListener(eventName, function(evt) {
          chai.assert.equal(evt.detail, eventDetail, 'expected CustomEvent detail');
          done();
        });

        var evt = new CustomEvent(eventName, {detail: eventDetail});
        document.body.dispatchEvent(evt);
      });
    