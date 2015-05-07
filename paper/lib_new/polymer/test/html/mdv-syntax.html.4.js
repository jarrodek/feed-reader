
    assert = chai.assert;
    window.addEventListener('polymer-ready', function() {
      var e = document.querySelector('mdv-holder');
      e.test = {
        bindAs: {value: 42},
        repeatIn: [{value: 1}, {value: 2}],
        math: {
          a: 1,
          b: 2,
          expected: [3, -1, 2, 'true', 'true', 'false', '1,2', 'true']
        },
        itself: e
      };
    });
  