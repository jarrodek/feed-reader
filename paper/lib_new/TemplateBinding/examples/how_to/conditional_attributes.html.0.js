
    document.addEventListener('DOMContentLoaded', function() {
      var t = document.getElementById('addRemoveAttribute');
      t.model = {
        data: {
          hide: false
        }
      };

      // Needed to detect model changes if Object.observe
      // is not available in the JS VM.
      Platform.performMicrotaskCheckpoint();
    });
    