
    var host = document.getElementById('host');
    var shadow = document.getElementById('shadow');
    var result = document.getElementById('result');
    var cancel;

    function pass(ev) {
      clearTimeout(cancel);
      ev.stopImmediatePropagation();
      result.classList.add('remove');
      result.classList.add('pass');
    }

    function fail(ev) {
      result.classList.remove('pass');
      result.classList.add('fail');
    }

    shadow.style.cssText = 'height: 100px; width: 100px; margin: 50px; background: gray; position: absolute;';

    var sr = host.createShadowRoot();
    var content = document.createElement('content');

    sr.appendChild(content);

    PolymerGestures.addEventListener(shadow, 'down', function() {
      cancel = setTimeout(fail, 1000);
    });

    PolymerGestures.addEventListener(content, 'tap', pass);
  