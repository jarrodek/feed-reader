
  addEventListener('polymer-ready', function() {
    // no-size container tests
    // test 1: flex layout attributes
    function getTestElements(test) {
      var t = document.getElementById(test);
      return {
        h1: getComputedStyle(t.querySelector('[horizontal] > [flex]')),
        h2: getComputedStyle(t.querySelector('[horizontal] > [flex][sized]')),
        v1: getComputedStyle(t.querySelector('[vertical] > [flex]')), 
        v2: getComputedStyle(t.querySelector('[vertical] > [flex][sized]'))
      };
    }
    //
    (function() {
      var e$ = getTestElements('test1');
      chai.assert.equal(e$.h1.width, e$.h2.width, 'unsized container: horizontal flex items have same width');
      chai.assert.equal(e$.v1.height, '0px', 'unsized container: vertical flex items have no intrinsic height');
    })();
    //
    // test 2: flex auto layout attributes
    (function() {
      var e$ = getTestElements('test2');
      chai.assert.notEqual(e$.h1.width, e$.h2.width, 'unsized container: horizontal flex auto items have intrinsic width + flex amount');
      chai.assert.notEqual(e$.v1.height, '0px', 'unsized container: vertical flex auto items have intrinsic height');
    })();
    //
    // test 3: flex auto-vertical layout attributes
    (function() {
      var e$ = getTestElements('test3');
      chai.assert.equal(e$.h1.width, e$.h2.width, 'unsized container: horizontal flex auto-vertical items have same width');
      chai.assert.notEqual(e$.v1.height, '0px', 'unsized container: vertical flex auto-vertical items have intrinsic height');
    })();
    //
    // Sized container tests
    // test 4: flex layout attributes
    (function() {
      var e$ = getTestElements('test4');
      chai.assert.equal(e$.h1.width, e$.h2.width, 'sized container: horizontal flex items have same width');
      chai.assert.equal(e$.v1.height, e$.v2.height, 'sized container: vertical flex items have same height');
    })();
    //
    // test 5: flex auto layout attributes
    (function() {
      var e$ = getTestElements('test5');
      chai.assert.notEqual(e$.h1.width, e$.h2.width, 'sized container: horizontal flex auto items have intrinsic width + flex amount');
      chai.assert.notEqual(e$.v1.height, '0px', 'sized container: vertical flex auto items have intrinsic height');
      chai.assert.notEqual(e$.v1.height, e$.v2.height, 'sized container: vertical flex auto items have intrinsic width + flex amount');
    })();
    //
    // test 6: flex auto-vertical layout attributes
    (function() {
      var e$ = getTestElements('test3');
      chai.assert.equal(e$.h1.width, e$.h2.width, 'unsized container: horizontal flex auto-vertical items have same width');
      chai.assert.notEqual(e$.v1.height, '0px', 'sized container: vertical flex auto-vertical items have intrinsic height');
      chai.assert.notEqual(e$.v1.height, e$.v2.height, 'sized container: vertical flex auto-vertical items have intrinsic width + flex amount');
    })();
    done();
  });
