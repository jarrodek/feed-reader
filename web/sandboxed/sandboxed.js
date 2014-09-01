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
});