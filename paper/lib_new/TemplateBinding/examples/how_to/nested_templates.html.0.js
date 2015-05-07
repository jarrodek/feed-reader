
    document.addEventListener('DOMContentLoaded', function() {
      var t = document.getElementById('example');
      t.model = { managers: [
        {
          name: 'Bob',
          employees: [{ name: 'Sally' }, { name: 'Tim' }, { name: 'Joe' }]
        },
        {
          name: 'Janet',
          employees: [{ name: 'Eric' }, { name: 'Jack' }, { name: 'Laura' }]
        },
        {
          name: 'Suzie',
          employees: [{ name: 'John' }, { name: 'Lucy' }, { name: 'Fred' }]
        },
      ]};

      // Needed to detect model changes if Object.observe
      // is not available in the JS VM.
      Platform.performMicrotaskCheckpoint();
    });
    