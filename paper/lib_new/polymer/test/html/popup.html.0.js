
      window.addEventListener('message', function(ev) {
        if (ev.data === 'close') {
          output.textContent += 'close request\n';
          ev.source.postMessage('popup-closed', location.origin);
          window.close();
        }
      });
      if (window.opener) {
        window.focus();
        output.textContent += 'send initialized';
        window.opener.postMessage('popup-initialized', location.origin);
      }
    