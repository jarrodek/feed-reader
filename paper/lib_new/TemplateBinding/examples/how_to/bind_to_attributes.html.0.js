
    document.addEventListener('DOMContentLoaded', function() {
      var t = document.getElementById('colors');
      t.model = {
        colors: [
          { color: 'red' },
          { color: 'blue' },
          { color: 'green' },
          { color: 'pink' }
        ]
      };
      // Needed to detect model changes if Object.observe
      // is not available in the JS VM.
      Platform.performMicrotaskCheckpoint();

      var b = document.getElementById('rotateText');
      b.addEventListener('click', function() {
        t.model.colors.push(t.model.colors.shift());

        Platform.performMicrotaskCheckpoint();
      });
    });
    