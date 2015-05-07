
    function test() {
      run();
      var span = document.querySelector('span');
      chai.assert.equal(span.textContent, 'Róbert Viðar Bjarnason');
      done();
    }

    if (HTMLImports.ready) {
      test();
    } else {
      addEventListener('HTMLImportsLoaded', test);
    }
  