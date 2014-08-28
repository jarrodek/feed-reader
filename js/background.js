/// Chrome App launch
chrome.app.runtime.onLaunched.addListener(function(launchData) {
    createAppWindow();
});
chrome.runtime.onSuspend.addListener(function() {
    feed.appopened = false;
});

var appConfig = {
    refreshRate: {
        'default': 10,
        'current': null
    },
    limits:{
        entries: 200
    }
};

var feed = {
    _queue: [],
    'appopened': false,
    'notifications': {},
    /**
     * Get (from sync storage) list of all feeds.
     * @param {Function} clb Callback function with Feed item
     * @returns {undefined}
     */
    'getFeedsList': function(clb) {
        console.log('Now getting feeds list.');
        rss_app.indexedDB.onerror = function(e){
          console.error('Unable read feeds list.', e);
        };
        rss_app.indexedDB.getFeeds(function(feeds) {
            rss_app.indexedDB.close();
            clb(feeds);
        });
        
    },
    'update': function() {
        console.log('Updating posts list in feeds.');
        this.getFeedsList(function(feeds) {
            console.log('Result feed list with:', feeds);
            if (!feeds)
                return;
            feed._queue = feed._queue.concat(feeds);
            console.log('update: queue.length = %d', feed._queue.length);
            feed._run();
        });
    },
    '_run': function() {
        if (this._queue.length === 0)
            return;
        var currentFeed = this._queue.shift();
        console.log('Get data for url: %s', currentFeed.url);
        this._getFeed(currentFeed);
    },
    '_getFeed': function(currentFeed) {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', currentFeed.url, true);
        xhr.addEventListener('load', feed._parseFeedResponse.bind(feed, currentFeed), false);
        xhr.addEventListener('error', function(e) {
            console.error(e);
            window.setTimeout(feed._run.bind(feed), 0);
        }, false);
        xhr.send();
    },
    '_parseFeedResponse': function(currentFeed, e) {
        function handleError(error) {
            //TODO: handle error
            console.error(error);
            window.setTimeout(feed._run.bind(feed), 0);
        }

        if (!(e.target.status >= 200 && e.target.status < 300)) {
            handleError();
            return;
        }

        var worker = new Worker('js/workers/parser.js');
        worker.onerror = function(event) {
            handleError(event);
            worker.terminate();
        };
        worker.onmessage = function(event) {
            worker.terminate();
            var data = event.data;
            if (data.error) {
                handleError(e);
                return;
            }
            feed.syncFeed(currentFeed, data);
            window.setTimeout(feed._run.bind(feed), 0);
        };
        worker.postMessage(e.target.response);
    },
    'syncFeed': function(currentFeed, newFeed) {
        
        var worker = new Worker('js/workers/feed_sync.js');
        worker.onerror = function(event) {
            handleError(event);
            worker.terminate();
        };
        worker.onmessage = function(event) {
            worker.terminate();
            
            var inserted = event.data.inserted;
            if(inserted){
                feed.notify(event.data.feedid,newFeed.title,inserted);
            }
        };
        worker.postMessage({
            'newFeed': newFeed,
            'currentFeed': currentFeed
        });
    },
    
    'notify': function(feedId, feedTitle, itemsCount){
        if(feed.appopened){
           var windows = chrome.app.window.getAll();
           if(windows.length === 0) return;
           windows.forEach(function(wnd){
               try{wnd.feedUpdated(feedId, feedTitle, itemsCount);}catch(e){};
           });
           return; 
        }
        var options = {
            type: "basic",
            title: "You have new items in RSS reader",
            message: itemsCount + ' new items in ' + feedTitle,
            iconUrl: chrome.runtime.getURL('/img/notification.png')
        };
        chrome.notifications.create("", options, function(id){
            feed.notifications[id] = feedId;
        });
    }
};

function createAppWindow(initialFeed){
    var url = 'rss_app.html';
    if(initialFeed){
        url += '#/feed/'+initialFeed;
    }
    chrome.app.window.create(url, {
        'id': '_mainWindow', 'bounds': {'width': 800, 'height': 600}
    });
    feed.appopened = true;
};

function onInit() {
    console.log('onInit');
    chrome.alarms.onAlarm.addListener(onAlarm);
    var period = appConfig.refreshRate.current || appConfig.refreshRate.default;
    chrome.alarms.create('feedownload', {'periodInMinutes': period});
    feed.update();
    chrome.notifications.onClicked.addListener(function(notificationId){
        if(!(notificationId in feed.notifications)) return;
        var feedId = feed.notifications[notificationId];
        delete feed.notifications[notificationId];
        createAppWindow(feedId);
    });
}
function onAlarm(alarm) {
    if (alarm && alarm.name === 'feedownload') {
        feed.update();
    } else {
        console.log('no alarm');
    }
}

onInit();
