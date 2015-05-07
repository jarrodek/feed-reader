
    result = document.createElement('div');
    result.id = 'result';

    function pass() {
      if (!result.parentNode) {
        document.body.appendChild(result);
      }
      result.className = 'pass';
    }
    function fail() {
      if (!result.parentNode) {
        document.body.appendChild(result);
      }
      result.className = 'fail';
    }

    pgae = PolymerGestures.addEventListener.bind(PolymerGestures);
    var box = document.getElementById('box');
    var ta = document.getElementById('input');

    var passTimeout;
    pgae(box, 'tap', function(ev) {
      document.body.removeChild(box);
      passTimeout = setTimeout(pass, 1000);
    });

    input.addEventListener('focus', function() {
      clearTimeout(passTimeout);
      fail();
    });

    input.addEventListener('click', function() {
      clearTimeout(passTimeout);
      fail();
    });

  