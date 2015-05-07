
      var link = document.createElement('link');
      link.href = 'imports/dedupe.html';
      link.rel = 'import';
      link.addEventListener('load', function(e) {
        console.log('dynamic link loaded', e.target.href);
      })
      document.head.appendChild(link);
    