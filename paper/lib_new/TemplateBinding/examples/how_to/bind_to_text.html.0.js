
    document.addEventListener('DOMContentLoaded', function() {
      var t = document.getElementById('text');
      t.model = {
        text: [
          { value: 'Fee' },
          { value: 'Fi' },
          { value: 'Fo' },
          { value: 'Fum' }
        ]
      };

      // Needed to detect model changes if Object.observe
      // is not available in the JS VM.
      Platform.performMicrotaskCheckpoint();

      var b = document.getElementById('rotateText');
      b.addEventListener('click', function() {
        t.model.text.push(t.model.text.shift());

        Platform.performMicrotaskCheckpoint();
      });
    });
    