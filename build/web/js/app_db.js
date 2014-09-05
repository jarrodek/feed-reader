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

var rss = rss || {};
/**
 * Namespace for Database connection.
 * @type type
 */
rss.db = {};
/**
 * A handler to current connection to the database.
 * @type IDBDatabase
 */
rss.db._db = null;
/**
 * Current database schema version.
 * @type Number
 */
rss.db._dbVersion = 6;
/**
 * Generic error handler.
 * @param {Error} e
 * @returns {undefined}
 */
rss.db.onerror = function(e) {
    console.error('rss::db:error');
    console.log(e.message);
};
/**
 * Open the database.
 * 
 * @returns {Promise} The promise when ready.
 */
rss.db.open = function(){
    return new Promise(function(resolve, reject) {
        if (rss.db._db) {
            resolve();
            return;
        }
        var request = indexedDB.open("rss_feeds", rss.db._dbVersion);
        request.onupgradeneeded = rss.db._dbUpgrade;
        request.onsuccess = function(e) {
            rss.db._db = e.target.result;
//            console.log('DB opened.');
//            console.log(rss.db._db);
            resolve();
        };
        request.onerror = reject;
    });
};
/**
 * Called when database verstion change.
 * 
 * This function will create new database structure.
 * 
 * @param {Event} e 
 * @returns {undefined}
 */
rss.db._dbUpgrade = function(e){
    console.group('Database upgrade');
    console.info('Upgrading the database to version %d.', rss.db._dbVersion);
    
    var db = e.target.result;
    e.target.transaction.onerror = rss.db.onerror;
    
    if (db.objectStoreNames.contains("feeds")) {
        db.deleteObjectStore("feeds");
        console.info('Datastore "feeds" has been deleted.');
    }
    if (db.objectStoreNames.contains("posts")) {
        db.deleteObjectStore("posts");
        console.info('Datastore "posts" has been deleted.');
    }
    
    console.info('Creating "feeds" datastore and indexes.');
    var feedstore = db.createObjectStore("feeds", {autoIncrement: true, keyPath: 'id'});
    feedstore.createIndex('feedid', 'feedid', {unique: true, multiEntry: false});
    feedstore.createIndex('url', 'url', {unique: true, multiEntry: false});
    
    console.info('Creating "posts" datastore and indexes.');
    //var poststore = db.createObjectStore("posts", {autoIncrement: true, keyPath: 'id'});
    var poststore = db.createObjectStore("posts", {keyPath: 'entryid'});
    //poststore.createIndex('entryid', 'entryid', {unique: true, multiEntry: false});
    poststore.createIndex('feedid', 'feedid', {unique: false, multiEntry: false});
    poststore.createIndex('unread', 'unread', {unique: false, multiEntry: false});
    poststore.createIndex('categories', 'categories', {unique: false, multiEntry: true});
    poststore.createIndex('starred', 'starred', {unique: false, multiEntry: false});
    poststore.createIndex('unread, feedid', ['unread', 'feedid'], {unique: false});
    console.groupEnd();
};
/**
 * Close a connection to the database.
 * @returns {undefined}
 */
rss.db.close = function(){
    if(rss.db._db === null) return;
    rss.db._db.close();
    rss.db._db = null;
};
/**
 * Get entries for given feed.
 * @param {Number} feedInternalDbId Feed database ID.
 * @returns {Promise} Resolved with an array of entries.
 */
rss.db.getEntries = function(feedInternalDbId) {
    return rss.db.open().then(function(){
        return rss.db._getEntries(feedInternalDbId);
    }).catch(function(e){
        console.error('can\'t call rss.db.open');
        throw e;
    });
};
rss.db._getEntries = function(feedInternalDbId){
    return new Promise(function(resolve, reject) {
        var transaction = rss.db._db.transaction(["posts"]);
//        console.log(transaction);
        transaction.onerror = reject;
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
                resolve(entries);
            }
        };
        
    });
};

rss.db.getAllEntries = function() {
    return rss.db.open().then(rss.db._getAllEntries);
};
rss.db._getAllEntries = function() {
    return new Promise(function(resolve, reject) {
        var transaction = rss.db._db.transaction(["posts"]);
        transaction.onerror = reject;
        var objectStore = transaction.objectStore("posts");
        var entries = [];
        var cursor = objectStore.openCursor();
        cursor.onerror = rss.db.onerror;
        cursor.onsuccess = function(event) {
            var cursor = event.target.result;
            if (cursor) {
                entries[entries.length] = cursor.value;
                cursor.continue();
            } else {
                resolve(entries);
            }
        };
    });
};

/**
 * Get all Feeds from Datastore.
 * @returns {Promise} The promise with entries read.
 */
rss.db.getFeeds = function() {
    return rss.db.open().then(rss.db._getFeeds);
};
rss.db._getFeeds = function() {
    return new Promise(function(resolve, reject) {
        var transaction = rss.db._db.transaction(["feeds"]);
        transaction.onerror = reject;
        var objectStore = transaction.objectStore("feeds");
        var entries = [];
        var cursor = objectStore.openCursor();
        cursor.onerror = rss.db.onerror;
        cursor.onsuccess = function(event) {
            var cursor = event.target.result;
            if (cursor) {
                entries[entries.length] = cursor.value;
                cursor.continue();
            } else {
                resolve(entries);
            }
        };
    });
};
/**
 * Add new Feed entry to the database.
 * At the begining the entry is only a feed URL. After next update data will be 
 * populated to the Feed object.
 * 
 * @param {String} feedUrl 
 * @returns {Promise} Fullfiled when ready.
 */
rss.db.addFeed = function(feedUrl) {
    return rss.db.open().then(function(){
        return rss.db._addFeed(feedUrl);
    });
};

rss.db._addFeed = function(feedUrl) {
    if (!feedUrl){
        throw "Specify feed url!";
    }
    
    return new Promise(function(resolve, reject) {
        var transaction = rss.db._db.transaction(["feeds"], "readwrite");
        transaction.onerror = reject;
        var objectStore = transaction.objectStore("feeds");
        transaction.oncomplete = resolve;
        var newFeed = new Feed();
        var data = newFeed.toJson();
        data.url = feedUrl;
        objectStore.add(data);
    });
};


/**
 * Udpate Feed data in the datastore.
 * @param {Feed} feed The Feed object.
 * @returns {Promise} Fullfiled when ready.
 */
rss.db.updateFeed = function(feed){
    return rss.db.open().then(function(){
        return rss.db._updateFeed(feed);
    });
};
rss.db._updateFeed = function(feed){
    return new Promise(function(resolve, reject) {
        var transaction = rss.db._db.transaction(["feeds"], "readwrite");
        transaction.onerror = reject;
        transaction.oncomplete = function(event) {
            resolve();
        };
        var objectStore = transaction.objectStore("feeds");
        objectStore.put(feed);
    });
};
/**
 * 
 * @param {Array} inserts Array of Feed object to be inserted.
 * @param {Array} updates Array of Feed object to be updated.
 * @returns {Promise} callend when done.
 */
rss.db.insertPosts = function(inserts, updates){
    return rss.db.open().then(function(){
        return rss.db._insertPosts(inserts, updates);
    });
};
rss.db._insertPosts = function(inserts, updates){
    return new Promise(function(resolve, reject) {
        var transaction = rss.db._db.transaction(["posts"], "readwrite");
        var objectStore = transaction.objectStore("posts");
        transaction.onerror = reject;
        transaction.oncomplete = resolve;
        for(var i=0, len=inserts.length; i<len; i++){
            var r = objectStore.add(inserts[i]);
//            r.onerror = function(e){
//                console.log("ADD ERROR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//                console.log(JSON.stringify(this))
//                for(var _e in e.target.error){
//                    console.log("Error: [" + _e + "]: " + e.target.error[_e]);
//                }
//            }.bind(inserts[i]);
        }
        for(var i=0, len=updates.length; i<len; i++){
            objectStore.put(updates[i]);
        }
    });
};

/**
 * Get all unread posts.
 * @returns {Promise} With an array of unread entries.
 */
rss.db.getUnread = function(){
    return rss.db.open().then(rss.db._getUnread);
};

rss.db._getUnread = function(){
    return new Promise(function(resolve, reject) {
        var transaction = rss.db._db.transaction(["posts"]);
        transaction.onerror = reject;
        var objectStore = transaction.objectStore("posts");
        var entries = [];
        
        var index = objectStore.index("unread");
        var range = IDBKeyRange.only(1);
        index.openCursor(range).onsuccess = function(event) {
            var cursor = event.target.result;
            if (cursor) {
                entries[entries.length] = cursor.value;
                cursor.continue();
            } else {
                resolve(entries);
            }
        };
    });
};