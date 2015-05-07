
      document.addEventListener('HTMLImportsLoaded', function() {
        var baseURI = location.href.replace('base/load-base.html', '').replace(location.search, '');
        chai.assert.equal(document.baseURI, baseURI, 'document.baseURI is correctly modified by base element');
        //
        chai.assert.equal(loadEvents, 3, 'expected # of load events');
        var test1 = getComputedStyle(document.querySelector('#test1')).backgroundColor;
        chai.assert.equal(test1, 'rgb(255, 0, 0)');
        var test2 = getComputedStyle(document.querySelector('#test2')).backgroundColor;
        chai.assert.equal(test2, 'rgb(0, 0, 255)');
        done();
      });
    