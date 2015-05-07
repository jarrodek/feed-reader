
    var work = document.querySelector('#work');
    
    function test(count) {
      console.log('test', count);
      clean();
      make(count);
      if (interval) {
        setTimeout(function() {
          test(count);
        }, 250);
      }
    }
    
    function make(count) {
      for (var i=0; i < count; i++) {
        work.appendChild(document.createElement('x-test'));
      }
    }
    
    function clean() {
      work.textContent = '';
    }
    
    var interval;
    function continuous() {
      interval = !interval;
      console.log(interval);
      if (interval) {
        test(100);
      } else {
        clearTimeout(interval);
      }
    }
  