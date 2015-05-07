
    document.addEventListener('DOMContentLoaded', function() {
      var t1 = document.getElementById('example1');
      t1.model = { name: 'Sam' };

      var t2 = document.getElementById('example2');
      t2.model = [{ name: 'Amy' }, { name: 'Lin' }, { name: 'Peter' }];

      // Needed to detect model changes if Object.observe
      // is not available in the JS VM.
      Platform.performMicrotaskCheckpoint();
    });
    