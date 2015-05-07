
var logElement = document.getElementById('log');

var iterations = 0;
var twiddle = document.createTextNode('');
var observer = new MutationObserver(runMutation).observe(twiddle, {characterData: true});
function runMutation() {
  setTimeout(function() {
    twiddle.textContent = iterations++;
  }, 0);
  logElement.innerHTML = "<p>runMutation called: " + Date.now() + "</p>" + logElement.innerHTML;
}

function runSetTimeout() {
  setTimeout(runSetTimeout, 0);
  logElement.innerHTML = "<p>runSetTimeout called: " + Date.now() + "</p>" + logElement.innerHTML;
}

function doStart() {
  setTimeout(runSetTimeout, 0);
  twiddle.textContent = iterations++;
}
