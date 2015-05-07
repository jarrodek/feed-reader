
      window.loadEvents = 0;
      (function() {
        function importLoaded(event) {
          window.loadEvents++;
          if (event.type === 'load' && event.target.import) {
            var s = event.target.import.querySelector('script');
            chai.assert.ok(s, 'load event target can be used to find element in import');
          }
        }

        function importError(event) {
          window.loadEvents++;
        }

        window.importLoaded = importLoaded;
        window.importError = importError;
      })();
    