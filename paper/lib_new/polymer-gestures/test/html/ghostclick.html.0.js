
    var result = document.createElement('div');
    result.id = 'result';

    function test() {
      if (!result.parentNode) {
        document.body.appendChild(result);
      }
    }

    function fail() {
      test();
      result.className = 'fail';
    }
    window.addEventListener('error', fail);

    var output = document.getElementById('output');
    function log(s) {
      output.textContent += s + '\n';
    }

    var remove = document.getElementById('remove');
    remove.addEventListener('click', function(ev) {
      ev.stopPropagation();
    });

    pgae = PolymerGestures.addEventListener.bind(PolymerGestures);

    var container = document.getElementById('container');
    var template = document.querySelector('template');

    var sr = container.createShadowRoot();
    sr.appendChild(template.content.cloneNode(true));

    var box = sr.getElementById('box');
    var a = box.parentNode;

    var wasClicked = false;

    pgae(a, 'click', function() {
      log('a click');
      wasClicked = true;
    });

    pgae(document.body, 'click', function() {
      log('body click');
      if (!box.parentNode) {
        fail();
      }
    });

    pgae(box, 'tap', function() {
      log('box tap, remove');
      if (remove.checked) {
        box.parentNode.removeChild(box);
      }
    });

    pgae(a, 'tap', function(ev) {
      log('a tap');
      setTimeout(function() {
        if (!wasClicked && box.parentNode) {
          fail();
        } else {
          test();
        }
      }, 1000);
    });
  