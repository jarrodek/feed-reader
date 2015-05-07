
    document.addEventListener('polymer-ready', function() {
      var xSheets = document.querySelector('x-sheets');
      
      function test(node, color) {
        var computedColor = getComputedStyle(node).backgroundColor;
        chai.assert.equal(computedColor, color, 'computed color matches expected color');
      }
      
      test(xSheets.$.red, 'rgb(255, 0, 0)');
      test(xSheets.$.blue, 'rgb(0, 0, 255)');
      test(xSheets.$.yellow, 'rgb(255, 255, 0)');
      done();
    });
  