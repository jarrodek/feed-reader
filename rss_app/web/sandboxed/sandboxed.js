window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.action !== "paste") {
        return;
    }
    document.querySelector('.content').innerHTML = data.html;
    var anchors = document.querySelectorAll('.content a');
    for (var i = 0, len = anchors.length; i < len; i++) {
        anchors[i].setAttribute('target', '_blank');
    }
    window.top.postMessage({'message':'ready', 'height': document.body.offsetHeight}, '*');
});

window.addEventListener('resize', function(e){
  //inform parent about current height
  window.top.postMessage({'message':'height-change', 'height': document.body.offsetHeight}, '*');
});

window.addEventListener('keydown', function(e){
  switch(e.keyCode){
    case 37: //left,
    case 39: //right
      window.top.postMessage({'message':'navigate', 'dir': e.keyCode === 37 ? 'prev':'next'}, '*');
    break;
  }
});