
    document.addEventListener('asyncElementsAdded', function() {
      setTimeout(function() {
        chai.assert.isTrue(window.asyncScript, 'async added script ran');
        var computed = getComputedStyle(document.querySelector('#asyncStyled'));
        chai.assert.equal(computed.backgroundColor, 'rgb(255, 0, 0)', 'async added style applied');
        done();
      }, 1);
    });
  