
var benchmark;
var goButton = document.getElementById('go');

var widthSelect = document.getElementById('widthSelect');
var depthSelect = document.getElementById('depthSelect');
var decorationSelect = document.getElementById('decorationSelect');
var instanceCountSelect = document.getElementById('instanceCountSelect');

var compoundCheckbox = document.getElementById('compoundBindings');
var oneTimeBindings = document.getElementById('oneTimeBindings');
var expressionCheckbox = document.getElementById('expressions');

var bindingDensityInput = document.getElementById('bindingDensityInput');

var statusSpan = document.getElementById('statusSpan');

var timesCanvas = document.getElementById('times');
var benchmarkSelect = document.getElementById('benchmarkSelect');
var configSelect = document.getElementById('configSelect');

var testDiv = document.getElementById('testDiv');
var ul = document.getElementById('legendList');
var rgbColor = 'rgba(100, 149, 237, .7)';

goButton.addEventListener('click', function() {
  goButton.disabled = true;
  goButton.textContent = 'Running...';
  ul.textContent = '';

  var bindingDensities = bindingDensityInput.value.split(',').map(function(val) {
    return Number(val) / 100;
  });


  var li = document.createElement('li');
  li.textContent = 'mdv';
  li.style.color = rgbColor;
  ul.appendChild(li);

  function benchmarkComplete(results) {
    if (Observer._allObserversCount > 4)
      alert('Error. All Observer Count: ' + Observer._allObserversCount);

    datasets = [];

    timesCanvas.height = 400;
    timesCanvas.width = 800;
    timesCanvas.setAttribute('style', '');

    var labels = bindingDensities.map(function(density) {
      return density * 100 + '%';
    });

    var timesArray = [results];

    var ctx = timesCanvas.getContext("2d");
    new Chart(ctx).Line({
      labels: labels,
      datasets: timesArray.map(function(times, i) {
        return {
          fillColor: 'rgba(255, 255, 255, 0)',
          strokeColor: rgbColor,
          pointColor: rgbColor,
          pointStrokeColor: "#fff",
          data: times
        };
      })
    }, {
      bezierCurve: false
    });

    goButton.disabled = false;
    goButton.textContent = 'Run Benchmarks';
    statusSpan.textContent = 'finished';
  }

  function updateStatus(b, variation, runCount) {
    statusSpan.textContent = (100 * b.density) + '% binding density, ' + runCount + ' runs';
  }

  var width = Number(widthSelect.value);
  var depth = Number(depthSelect.value);
  var decoration = Number(decorationSelect.value);
  var instanceCount = Number(instanceCountSelect.value);

  var benchmarks = bindingDensities.map(function(density) {
    return new MDVBenchmark(testDiv, density, width, depth, decoration,
                            instanceCount,
                            oneTimeBindings.checked,
                            compoundBindings.checked,
                            expressionCheckbox.checked);
  });

  Benchmark.all(benchmarks, 0, updateStatus).then(benchmarkComplete);
});
