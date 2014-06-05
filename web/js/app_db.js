var rss_app = {
    'indexedDB': {
        db: null,
        onerror: function(e) {},
        open: function(callback) {
            if (rss_app.indexedDB.db !== null) {
                callback();
                return;
            }
            var version = 4;
            var request = indexedDB.open("rss_feeds", version);
            request.onupgradeneeded = function(e) {
                console.log('onupgradeneeded', e);
                var db = e.target.result;
                e.target.transaction.onerror = rss_app.indexedDB.onerror;

                if (db.objectStoreNames.contains("feeds")) {
                    db.deleteObjectStore("feeds");
                }
                if (db.objectStoreNames.contains("posts")) {
                    db.deleteObjectStore("posts");
                }
                var feedstore = db.createObjectStore("feeds", {autoIncrement: true, keyPath: 'id'});
                feedstore.createIndex('feedid', 'feedid', {unique: true, multiEntry: false});
                feedstore.createIndex('url', 'url', {unique: true, multiEntry: false});
                var poststore = db.createObjectStore("posts", {autoIncrement: true, keyPath: 'id'});
                poststore.createIndex('entryid', 'entryid', {unique: true, multiEntry: false});
                poststore.createIndex('categories', 'categories', {unique: false, multiEntry: true});
                poststore.createIndex('feedid', 'feedid', {unique: false, multiEntry: false});
                poststore.createIndex('unread', 'unread', {unique: false, multiEntry: false});
                poststore.createIndex('starred', 'starred', {unique: false, multiEntry: false});
                poststore.createIndex('unread, feedid', ['unread', 'feedid'], {unique: false});
            };
            request.onsuccess = function(e) {
                rss_app.indexedDB.db = e.target.result;
                callback();
            };
            request.onerror = rss_app.indexedDB.onerror;
        },
        
        close: function(){
            rss_app.indexedDB.db.close();
            rss_app.indexedDB.db = null;
        },
        
        getFeedPosts: function(feedInternalDbId, callback) {
            rss_app.indexedDB.open(function() {
                var transaction = rss_app.indexedDB.db.transaction(["posts"]);
                transaction.onerror = rss_app.indexedDB.onerror;
                var objectStore = transaction.objectStore("posts");
                var entries = [];
                var index = objectStore.index("feedid");
                var range = IDBKeyRange.only(feedInternalDbId);
                index.openCursor(range).onsuccess = function(event) {
                    var cursor = event.target.result;
                    if (cursor) {
                        entries[entries.length] = cursor.value;
                        cursor.continue();
                    } else {
                        callback(entries);
                    }
                };
            });
        },
        getFeeds: function(callback) {
            rss_app.indexedDB.open(function() {
                var transaction = rss_app.indexedDB.db.transaction(["feeds"]);
                transaction.onerror = rss_app.indexedDB.onerror;
                var objectStore = transaction.objectStore("feeds");
                var entries = [];
                var cursor = objectStore.openCursor();
                cursor.onerror = rss_app.indexedDB.onerror;
                cursor.onsuccess = function(event) {
                    var cursor = event.target.result;
                    if (cursor) {
                        entries[entries.length] = cursor.value;
                        cursor.continue();
                    } else {
                        callback(entries);
                    }
                };
            });
        },
        addFeed: function(feedUrl) {
            if (!feedUrl)
                throw "Specyfi feed url";
            rss_app.indexedDB.open(function() {
                var transaction = rss_app.indexedDB.db.transaction(["feeds"], "readwrite");
                transaction.onerror = rss_app.indexedDB.onerror;
                var objectStore = transaction.objectStore("feeds");

                transaction.oncomplete = function(event) {
                    console.info('Feed added');
                };
                

                var newFeed = new Feed();
                var data = newFeed.toJson();
                data.url = feedUrl;
                objectStore.add(data);
            });
        },
        
        updateFeed: function(feed, clb){
            rss_app.indexedDB.open(function() {
                var transaction = rss_app.indexedDB.db.transaction(["feeds"], "readwrite");
                transaction.onerror = rss_app.indexedDB.onerror;
                transaction.oncomplete = function(event) {
                    clb();
                };
                var objectStore = transaction.objectStore("feeds");
                objectStore.put(feed);
            });
        },
        
        insertPosts: function(inserts, updates, clb){
            rss_app.indexedDB.open(function() {
                var transaction = rss_app.indexedDB.db.transaction(["posts"], "readwrite");
                transaction.onerror = rss_app.indexedDB.onerror;
                var objectStore = transaction.objectStore("posts");
                transaction.oncomplete = clb;
                for(var i=0, len=inserts.length; i<len; i++){
                    objectStore.add(inserts[i]);
                }
                for(var i=0, len=updates.length; i<len; i++){
                    objectStore.put(updates[i]);
                }
            });
        }

    }
};