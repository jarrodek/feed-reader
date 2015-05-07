
    document.addEventListener('polymer-ready', function() {
      var foo = document.querySelector('x-sheet-main-doc');
      var color = 'rgb(255, 0, 0)';
      chai.assert.equal(getComputedStyle(foo.$.div).backgroundColor, color,
        'computed color matches expected color');

      var outerDiv = document.querySelector('.red1');
      chai.assert.equal(getComputedStyle(outerDiv).backgroundColor, color,
        'computed color matches expected color');  
      done();
    });
  