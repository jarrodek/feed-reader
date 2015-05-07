

var p = document.querySelector('[draggable]');
var img = document.querySelector('img');
p.ondragstart = function(e) {
  e.dataTransfer.setDragImage(img, 50, 50);
};

