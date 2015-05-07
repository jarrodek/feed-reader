
      changes = 0;
      doneChanges = 4;
      function checkDone() {
        if (doneChanges == ++changes) {
          done();
        }
      }
    