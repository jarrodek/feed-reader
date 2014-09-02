/**
 * This page is is used to remove HTML tags from received entries content.
 * For each entry it will create a child node, then it will innerHTML the content 
 * and get innerText as a textual data only.
 * 
 * @param {type} param1
 * @param {type} param2
 */
window.addEventListener('message', function(event) {
    var data = event.data;
    if(!data.action || data.action !== "sanitize"){ return; }
    
    var entries = data.entries;
    if(!entries.length){
        window.postMessage({"action":"sanitized","entries": []}, "*");
        return;
    }
    rss.sanitizer.sanitize(entries, function(parsed){
        window.postMessage({"action":"sanitized","entries": parsed}, "*");
    });
    
});

var rss = rss || {};
rss.sanitizer = {};

rss.sanitizer.sanitize = function(entries, callback){
    for(var i=0, len=entries.length; i<len; i++){
        var entry = entries[i];
        var parent = document.createElement('div');
        parent.innerHTML = entry.content;
        entry.text = parent.innerText;
        parent = null;
    }
    console.log('Sanitizer result:', entries);
    callback.call(window, entries);
};