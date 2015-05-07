
  (function() {
  var div = document.createElement('div');

  Polymer('test-me', {
    diff: null,
    data: null,
    diffmode: '',
    viewurl: '',
    active: false,
    hasBeenActivated: false,

    ready: function() {
      console.time('mdv');
      console.profile('mdv');
    	this.data = window.data;
      this.hasBeenActivated = true;
      Platform.performMicrotaskCheckpoint();

      var observer = new MutationObserver(function() {
        console.profileEnd('mdv');
        console.timeEnd('mdv');
      });
      observer.observe(div, { attributes: true });
      div.setAttribute('foo', 'bar');
    }
  });

  })();
  