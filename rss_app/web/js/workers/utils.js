/**
 * Rss app namespace
 * @type rss
 */
var rss = rss || {};
/**
 * Utils service namespace.
 * @type type
 */
rss.utils = {};
/**
 * 
 * @param {String} content The entry content to scan.
 * @returns {undefined}
 */
rss.utils.extractImageUrl = function(content) {
    var reg = /<img.*?src="(.*?)"/;
    var match = content.match(reg);
    if (!match) {
        return null;
    }
    var url = match[1];
    if (url.indexOf('//') === 0) {
        url = 'https:' + url;
    }
    return url;
};
/**
 * Download the image and save it in blob: storage.
 * @param {String} url URL of the image to download.
 * @returns {Promise}
 */
rss.utils.loadImageBlob = function(url) {
    return rss.utils.getBlob(url)
            .then(rss.utils.parseResponse)
            .then(rss.utils.getWindowUrl).catch(function(e){
                console.error(e);
            });
};

rss.utils.getBlob = function(url) {
    return new Promise(function(resolve, reject) {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', url, true);
        xhr.responseType = 'blob';
        xhr.addEventListener('load', function(e) {
            resolve(e.target);
        });
        xhr.addEventListener('error', function(e) {
            reject(e);
        });
        xhr.send();
    });
};
rss.utils.parseResponse = function(xhr) {
    return new Promise(function(resolve, reject) {
        if (xhr.status > 400) {
            throw Error(xhr.statusText);
        }
        resolve(xhr.response);
    });
};
rss.utils.getWindowUrl = function(blob) {
    return URL.createObjectURL(blob);
};