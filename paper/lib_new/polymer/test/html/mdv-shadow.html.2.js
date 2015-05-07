
    // mocha stomps window.onerror, save for failure case
    var htmlsuite_fail = window.onerror;
    var runner = mocha.run();
    runner.on('fail', function(test, err) {
      htmlsuite_fail(err.toString());
    });
    runner.on('end', function() {
      runner.failures || done();
    });
  