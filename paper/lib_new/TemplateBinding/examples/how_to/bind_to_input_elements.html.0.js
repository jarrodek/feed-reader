
    document.addEventListener('DOMContentLoaded', function() {
      var t = document.getElementById('input');
      t.model = {
        input: {
        	amount: 10,
        	toggle: true,
        	radio1: true,
        	radio2: false,
        	radio3: false
        }
      };

      // Needed to detect model changes if Object.observe
      // is not available in the JS VM.
      Platform.performMicrotaskCheckpoint();
    });
    