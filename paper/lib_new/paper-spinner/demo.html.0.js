
    var t = document.querySelector('template');
    t.toggle = function() {
      var spinners = document.querySelectorAll('paper-spinner');
      Array.prototype.forEach.call(spinners, function(spinner) {
        spinner.active = !spinner.active;
      });
    }
  