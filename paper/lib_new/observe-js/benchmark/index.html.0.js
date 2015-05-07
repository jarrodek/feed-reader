
var benchmark;
var goButton = document.getElementById('go');

var objectCountInput = document.getElementById('objectCountInput');
var mutationCountInput = document.getElementById('mutationCountInput');

var statusSpan = document.getElementById('status');

var timesCanvas = document.getElementById('times');
var benchmarkSelect = document.getElementById('benchmarkSelect');
var configSelect = document.getElementById('configSelect');

function changeBenchmark() {
  benchmark = window[benchmarkSelect.value];
  configSelect.textContent = '';
  benchmark.configs.forEach(function(config) {
    var option = document.createElement('option');
    option.textContent = config;
    configSelect.appendChild(option);
  });

  document.title = benchmarkSelect.value;
}

benchmarkSelect.addEventListener('change', changeBenchmark);

changeBenchmark();
var ul = document.getElementById('legendList');
var colors = [
  [0, 0, 255],
  [138,43,226],
  [165,42,42],
  [100,149,237],
  [220,20,60],
  [184,134,11]
].map(function(rgb) {
  return 'rgba(' + rgb.join(',') + ',.7)';
});

goButton.addEventListener('click', function() {
  goButton.disabled = true;
  goButton.textContent = 'Running...';
  ul.textContent = '';

  var objectCounts = objectCountInput.value.split(',').map(function(val) {
    return Number(val);
  });
  var mutationCounts = mutationCountInput.value.split(',').map(function(val) {
    return Number(val);
  });

  mutationCounts.forEach(function(count, i) {
    var li = document.createElement('li');
    li.textContent = count + ' mutations.'
    li.style.color = colors[i];
    ul.appendChild(li);
  });

  var results = [];

  function benchmarkComplete(times) {
    timesArray = [];
    var index = 0;


    mutationCounts.forEach(function(mutationCount, i) {
      timesArray.push([]);
      objectCounts.forEach(function(objectCount, j) {
        timesArray[i][j] = times[j][i];
      });
    });

    timesCanvas.height = 400;
    timesCanvas.width = 800;
    timesCanvas.setAttribute('style', '');

    var ctx = timesCanvas.getContext("2d");
    new Chart(ctx).Line({
      labels: objectCounts,
      datasets: timesArray.map(function(times, i) {
        return {
          fillColor: 'rgba(255, 255, 255, 0)',
          strokeColor: colors[i],
          pointColor: colors[i],
          pointStrokeColor: "#fff",
          data: times
        };
      })
    }, {
      bezierCurve: false
    });

    goButton.disabled = false;
    goButton.textContent = 'Run Benchmarks';
    statusSpan.textContent = '';
  }

  function updateStatus(benchmark, mutationCount, count) {
    statusSpan.textContent = 'Testing: ' +
        benchmark.objectCount + ' objects, ' +
        mutationCount + ' mutations ... ' +
        count + ' runs';
  }

  var benchmarks = objectCounts.map(function(objectCount) {
    return new benchmark(configSelect.value, objectCount);
  });

  Benchmark.all(benchmarks, mutationCounts, updateStatus)
    .then(benchmarkComplete);
});
