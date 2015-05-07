
    document.addEventListener('DOMContentLoaded', function() {
      var t = document.getElementById('example');
      t.model = {
        show: true
      };

      // Needed to detect model changes if Object.observe
      // is not available in the JS VM.
      Platform.performMicrotaskCheckpoint();
    });
    