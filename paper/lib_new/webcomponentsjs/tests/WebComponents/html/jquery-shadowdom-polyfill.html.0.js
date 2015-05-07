
    $(document).ready(function() {
      var host = $('#host')[0];
      var sr = host.createShadowRoot();
      sr.innerHTML = 'Light: <content></content>; Shadow: <span>qwert</span>';
      requestAnimationFrame(done);
    });
  