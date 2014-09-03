/* 
 * Copyright 2014 Paweł Psztyć.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//rss namespace.
var rss = rss || {};
// Rss config object namespace
rss.config = {};
//Rss app namespace
rss.app = {};
/**
 * Tells the app how often update feeds data.
 * @type Object
 */
rss.config.refreshRate = {
    /**
     * The refresh rate in minutes.
     * @type Number
     * @default 10 minutes
     */
    'current': 10
};
/**
 * The limits for feed's entries amount.
 * @type Object
 */
rss.config.limits = {
    /**
     * The maximum number of read entries holded in database.
     * @type Number
     * @default 200
     */
    read: 200
};
/**
 * Restore config from sync storage.
 * @param {Function} callback Callback function when restored.
 * @returns {undefined}
 */
rss.config.restore = function(callback){
    var restoreData = {
        'readLimit': null,
        'refreshRate': null
    };
    chrome.storage.sync.get(restoreData, function(restored){
        if(restored.readLimit){
            rss.config.limits.read = restored.readLimit;
        }
        if(restored.refreshRate){
            rss.config.refreshRate.current = restored.refreshRate;
        }
        callback.call(rss);
    });
};


/**
 * A queue of feeds to be downloaded.
 * @type Array
 */
rss.app._queue = [];
/**
 * Currently opened app window.
 * If null no window has been opened.
 * @type ChromeWindow
 */
rss.app.window = null;
/**
 * This is holder for notifications data.
 * When the user click on the notification the app will restore notification
 * data from this object.
 * @type Object
 */
rss.app.notifications = {
    /**
     * Data for opened notifications.
     * @type Object
     */
    'opened': {},
    /**
     * Temp data for pending notifications.
     * @type Array
     */
    'data': []
};
/**
 * Get from the sync storage list of all feeds.
 * @param {Function} callback Callback function. It's parameter will hold
 *  a list of Feed objects.
 * @returns {undefined}
 */
rss.app.getFeedsList = function(callback){
    console.log('Now getting feeds list.');
    rss.db.onerror = function(e) {
        console.error('Unable read feeds list.', e);
    };
    rss.db.getFeeds(function(feeds) {
        rss.db.close();
        callback(feeds);
    });
};
/**
 * This function should be called to update feeds data.
 * It will get list of feeds, insert it to the queue and run the queue.
 
 * @returns {undefined}
 */
rss.app.update = function(){
    console.log('Updating posts list in feeds.');
        
    rss.app.notifyLoading(true);
    rss.app.getFeedsList(function(feeds) {
        console.log('Result feed list with:', feeds);
        if (!feeds){
            rss.app.notifyLoading(false);
            return;
        }
        rss.app._queue = rss.app._queue.concat(feeds);
        console.log('update: queue.length = %d', rss.app._queue.length);
        rss.app._run();
    });
};


/**
 * Run the queue. 
 * Each queue item is a RSS/Atom feed. It will be downloaded and parsed.
 * New items will be synchronized with the database.
 * @returns {undefined}
 */
rss.app._run = function(){
    if (rss.app._queue.length === 0){
        rss.app.notifyLoading(false);
        rss.app.showNotifications();
        return;
    }
    var feed = rss.app._queue.shift();
    console.log('Get data for url: %s', feed.url);
    rss.app._getFeedEntries(feed);
};
/**
 * Download Feed entries and send to parser.
 * 
 * @param {Feed} feed
 * @returns {undefined}
 */
rss.app._getFeedEntries = function(feed){
    var xhr = new XMLHttpRequest();
    xhr.open('GET', feed.url, true);
    xhr.addEventListener('load', rss.app._parseFeedResponse.bind(rss.app, feed), false);
    xhr.addEventListener('error', function(e) {
        console.error(e);
        //TODO: mark feed as invalid.
        window.setTimeout(rss.app, 0);
    }, false);
    xhr.send();
};
/**
 * Send data to the parser.
 * Parser is a Worker running in separate thread. Results will be passed to the
 * sync serwice.
 * 
 * @param {Feed} feed
 * @param {Event} e
 * @returns {undefined}
 */
rss.app._parseFeedResponse = function(feed, e){
    function handleError(error) {
        //TODO: handle error
        console.error(error);
        window.setTimeout(rss.app._run, 0);
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
        rss.app.syncFeed(feed, data);
        window.setTimeout(rss.app._run, 0);
    };
    worker.postMessage({'url': feed.url, 'data': e.target.response});
};
/**
 * This function will run another service responsible for synchronizing
 * entries data with the database.
 * 
 * @param {Feed} feed Current feed
 * @param {Object} newFeed Data to be synchronized
 * @returns {undefined}
 */
rss.app.syncFeed = function(feed, newFeed) {
    
    function handleError(error) {
        //TODO: handle error
        console.error(error);
        window.setTimeout(rss.app._run, 0);
    }
    
    var worker = new Worker('js/workers/feed_sync.js');
    worker.onerror = function(event) {
        handleError(event);
        worker.terminate();
    };
    worker.onmessage = function(event) {
        worker.terminate();
        var inserted = event.data.inserted;
        if (inserted) {
            rss.app.notifyEntries(event.data.feedid, newFeed.title, inserted);
        }
    };
    worker.postMessage({
        'newFeed': newFeed,
        'currentFeed': feed/*,
        'readLimit': rss.config.limits.read*/
    });
};
/**
 * Notify about new entires in the feed.
 * 
 * This function will not show notifications! The app must call rss.app.showNotifications
 * function in order to display all notifications.
 * 
 * @param {Number} feedId Feed ID
 * @param {String} feedTitle Feed title
 * @param {Number} inserted Number of new items.
 * @returns {undefined}
 */
rss.app.notifyEntries = function(feedId, feedTitle, inserted) {
    if (rss.app.window) {
        rss.app.window.contentWindow.feedUpdated(feedId);
        return;
    }
    var data = {
        'id': feedId,
        'title': feedTitle,
        'count': inserted
    };
    rss.app.notifications.data.push(data);
};

rss.app.showNotifications = function(){
    if(rss.app.notifications.data.length === 0){
        return;
    }
    
    //var icon = chrome.runtime.getURL('/img/notification.png');
    var icon = chrome.runtime.getURL('/img/ico_128.png');
    var options = {};
    var showFeed = -1;
    if(rss.app.notifications.data.length === 1){
        var _n = rss.app.notifications.data.shift();
        options = {
            type: "basic",
            title: "You have new articles to read!",
            message: _n.count + ' new posts in ' + _n.title,
            iconUrl: icon
        };
        showFeed = _n.id;
    } else {
        var feedsCount = 0, itemsCount = 0, items = [];
        while(rss.app.notifications.data.length > 0){
            var _n = rss.app.notifications.data.shift();
            feedsCount++;
            itemsCount += _n.count;
            items[items.length] = {
                'title': _n.count + ' new articles.',
                'message': 'in '+_n.title
            };
        }
        options = {
            type: "list",
            title: "You have "+itemsCount+" new articles to read!",
            message: feedsCount + ' feeds has been updated.',
            iconUrl: icon
        };
        if(items.length > 0){
            options['items'] = items;
        }
    }
    chrome.notifications.create("", options, function(id) {
        rss.app.notifications.opened[id] = showFeed;
    });
};

/**
 * Notify the app (if the window has been opened) that Feeds are now updated
 * (loading set to true) or has been updated (loading set to false).
 * @param {boolean} loading
 * @returns {undefined}
 */
rss.app.notifyLoading = function(loading){
    if(!rss.app.window) return;
    
    if (typeof rss.app.window.contentWindow.feedLoading !== 'undefined') {
        rss.app.window.contentWindow.feedLoading(loading);
    }
};
/**
 * Create a new app window.
 * 
 * @param {Number} initialFeed If this parameter is present the app will 
 *  show selected feed instead of "unread".
 *  
 * @returns {undefined}
 */
rss.app.createAppWindow = function(initialFeed) {
    var url = 'rss_app.html';
    if (initialFeed && initialFeed !== -1) {
        url += '#/feed/' + initialFeed;
    }
    chrome.app.window.create(url, {
        'id': 'rss_app_mainWindow', 'innerBounds': {
            'minWidth': 600
        }
    }, function(createdWindow) {
        rss.app.window = createdWindow;
        console.info('App window has been opened.');
    });
};

rss.app.init = function() {
    console.log('Initializing the background app.');
    rss.app._setupOpenHandlers();
    rss.app._setupCloseHandlers();
    rss.config.restore(function(){
        rss.app._setupAlarm();
        rss.app._setupNotifications();
        rss.app.update();
    });
};

rss.app._setupAlarm = function() {
    chrome.alarms.clear('feedownload', function(){
        chrome.alarms.onAlarm.addListener(rss.app.onAlarm);
        chrome.alarms.create('feedownload', {'periodInMinutes': rss.config.refreshRate.current});
    });
};

rss.app._setupNotifications = function() {
    chrome.notifications.onClicked.addListener(function(notificationId) {
        if (!(notificationId in rss.app.notifications.opened))
            return;
        var feedId = rss.app.notifications.opened[notificationId];
        delete rss.app.notifications.opened[notificationId];
        rss.app.createAppWindow(feedId);
    });
};
rss.app._setupCloseHandlers = function() {
    chrome.app.window.onClosed.addListener(function() {
        rss.app.window = null;
        console.info('App window has been closed.');
    });
    chrome.runtime.onSuspend.addListener(function() {
        rss.app.window = null;
        console.info('App window has been closed (backgroud page unloaded).');
    });
};
rss.app._setupOpenHandlers = function() {
    chrome.app.runtime.onLaunched.addListener(function(launchData) {
        rss.app.createAppWindow();
    });
};
rss.app.onAlarm = function(alarm){
    if (alarm && alarm.name === 'feedownload') {
        rss.app.update();
    }
};



// Bootstrap the app
rss.app.init();