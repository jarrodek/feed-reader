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

importScripts('../app_db.js');

/**
 * http://stackoverflow.com/a/14853974/1127848
 * @param {type} array
 * @returns {Boolean}
 */
Array.prototype.equals = function (array) {
    // if the other array is a falsy value, return
    if (!array)
        return false;

    // compare lengths - can save a lot of time 
    if (this.length != array.length)
        return false;

    for (var i = 0, l=this.length; i < l; i++) {
        // Check if we have nested arrays
        if (this[i] instanceof Array && array[i] instanceof Array) {
            // recurse into the nested arrays
            if (!this[i].equals(array[i]))
                return false;       
        }           
        else if (this[i] != array[i]) { 
            // Warning - two different object instances will never be equal: {x:20} != {x:20}
            return false;   
        }           
    }       
    return true;
};

self.onmessage = function(e) {
    rss.sync.sync(e.data);
};

/**
 * Rss app namespace
 * @type rss
 */
var rss = rss || {};
/**
 * Sync service namespace.
 * @type type
 */
rss.sync = {};
rss.sync.dbposts = {};
rss.sync.newFeed = [];
rss.sync.currentFeed = null;
/**
 * Synchronize feed entries with new data.
 * @param {Object} options Options passed from the background page.
 * @returns {undefined}
 */
rss.sync.sync = function(options){
    rss.sync.newFeed = options.newFeed;
    rss.sync.currentFeed = options.currentFeed;
    rss.sync._syncFeed();
};
/**
 * Perform the synchronization process on current data.
 * It will update Feed itself and then it will synchronize Entries data.
 * @returns {undefined}
 */
rss.sync._syncFeed = function(){
    var currentFeed = rss.sync.currentFeed;
    var feedNewData = rss.sync.newFeed;
    var feedChanged = false;
    
    if(currentFeed.feedid != feedNewData.feedid){
        currentFeed.feedid = feedNewData.feedid;
        feedChanged = true;
//        console.log('Feed\'s "feedid" is different. Need update Feed object. '
//            + 'Current: ' + currentFeed.feedid + ', new: ' + feedNewData.feedid);
    }
    if(currentFeed.title != feedNewData.title){
        currentFeed.title = feedNewData.title;
        feedChanged = true;
//        console.log('Feed\'s "title" is different. Need update Feed object. '
//            + 'Current: ' + currentFeed.title + ', new: ' + feedNewData.title);
    }
    if(currentFeed.subtitle != feedNewData.subtitle){
        currentFeed.subtitle = feedNewData.subtitle;
        feedChanged = true;
//        console.log('Feed\'s "subtitle" is different. Need update Feed object. '
//            + 'Current: ' + currentFeed.subtitle + ', new: ' + feedNewData.subtitle);
    }
    if(currentFeed.author != feedNewData.author){
        if(!currentFeed.author){
            currentFeed.author = {
                name: null,
                email: null,
                image: {
                    'src': null,
                    'width': null,
                    'height': null
                },
                url: null
            };
        }
        if(currentFeed.author.name != feedNewData.author.name){
//            console.log('Feed\'s "author.name" is different. ' 
//                + 'Need update Feed object. Current: ' + currentFeed.author.name 
//                + ', new: ' + feedNewData.author.name);
            feedChanged = true;
            currentFeed.author.name = feedNewData.author.name;
        }
        if(currentFeed.author.email != feedNewData.author.email){
//            console.log('Feed\'s "author.email" is different. ' 
//                + 'Need update Feed object. Current: ' + currentFeed.author.email 
//                + ', new: ' + feedNewData.author.email);
            feedChanged = true;
            currentFeed.author.email = feedNewData.author.email;
        }
        if(currentFeed.author.url != feedNewData.author.url){
//            console.log('Feed\'s "author.name" is different. '
//                    + 'Need update Feed object. Current: ' + currentFeed.author.url 
//                    + ', new: ' + feedNewData.author.url);
            feedChanged = true;
            currentFeed.author.url = feedNewData.author.url;
        }
        if(currentFeed.author.image.src != feedNewData.author.image.src){
//            console.log('Feed\'s "author.image.src" is different. '
//                    + 'Need update Feed object. Current: ' + currentFeed.author.image.src 
//                    + ', new: ' + feedNewData.author.image.src);
            feedChanged = true;
            currentFeed.author.image.src = feedNewData.author.image.src;
        }
        if(currentFeed.author.image.width != feedNewData.author.image.width){
//            console.log('Feed\'s "author.image.width" is different. '
//                    + 'Need update Feed object. Current: ' + currentFeed.author.image.width 
//                    + ', new: ' + feedNewData.author.image.width);
            feedChanged = true;
            currentFeed.author.image.width = feedNewData.author.image.width;
        }
        if(currentFeed.author.image.height != feedNewData.author.image.height){
//            console.log('Feed\'s "author.image.height" is different. ' 
//                    + 'Need update Feed object. Current: ' + currentFeed.author.image.height 
//                    + ', new: ' + feedNewData.author.image.height);
            feedChanged = true;
            currentFeed.author.image.height = feedNewData.author.image.height;
        }
    }
    if(!currentFeed.categories.equals(feedNewData.categories)){
        currentFeed.categories = feedNewData.categories;
        feedChanged = true;
//        console.log('Feed\'s "categories" is different. Need update Feed object. ' 
//                + 'Current: ' + currentFeed.categories + ', new: ' + feedNewData.categories);
    }
    if(currentFeed.etag != feedNewData.etag){
        currentFeed.etag = feedNewData.etag;
        feedChanged = true;
//        console.log('Feed\'s "etag" is different. Need update Feed object. Current: ' 
//                + currentFeed.etag + ', new: ' + feedNewData.etag);
    }
    if(currentFeed.updated != feedNewData.updated){
        currentFeed.updated = feedNewData.updated;
        feedChanged = true;
//        console.log('Feed\'s "updated" is different. Need update Feed object. Current: ' 
//                + currentFeed.updated + ', new: ' + feedNewData.updated);
    }
    if(currentFeed.pageurl != feedNewData.pageurl){
        currentFeed.pageurl = feedNewData.pageurl;
        feedChanged = true;
//        console.log('Feed\'s "pageurl" is different. Need update Feed object. Current: ' 
//                + currentFeed.pageurl + ', new: ' + feedNewData.pageurl);
    }
    if(feedChanged){
        rss.db.updateFeed(currentFeed, function(){
//            console.info('Feed has been updated');
//            console.info(JSON.stringify(currentFeed));
        });
    } else {
//        console.log('Feed\'s hasn\'t changed.');
    }

    rss.db.getEntries(rss.sync.currentFeed.id, function(posts){
        for(var i=0, len=posts.length; i<len; i++){
            rss.sync.dbposts[posts[i].entryid] = posts[i];
        }
        rss.sync.dbposts.length = posts.length;
        rss.sync._syncContent();
    });
};
/**
 * Synchronize FeedEntry data.
 * It will find an already existing feed entries in the datastore and exclude
 * it from inserting.
 * 
 * @returns {undefined}
 */
rss.sync._syncContent = function(){
    var inserts = [];
    var updates = [];
    for(var i=0, len=rss.sync.newFeed.entries.length; i<len; i++){
        var newEntry = rss.sync.newFeed.entries[i];
        if(newEntry.entryid in rss.sync.dbposts){
            var existing = rss.sync.dbposts[newEntry.entryid];
            var toUpdate = rss.sync._checkEntry(existing, newEntry);
            if(toUpdate !== null){
                updates[updates.length] = toUpdate;
            }
        } else {
            newEntry['new'] = 1;
            newEntry['unread'] = 1;
            newEntry['feedid'] = rss.sync.currentFeed.id;
            newEntry['starred'] = 0;
            try{
                var d = new Date(newEntry['published']);
                newEntry['createtime'] = d.getTime();
            } catch(e){}
            inserts[inserts.length] = newEntry;
        }
    }
    rss.sync.sanitize(inserts, updates);
};
rss.sync._checkEntry = function(existing, arrival){
    var entryChanged = false;
    if(existing.entryid !== arrival.entryid){
        existing.entryid = arrival.entryid;
        entryChanged = true;
    }
    if(existing.published !== arrival.published){
        existing.published = arrival.published;
        entryChanged = true;
    }
    if(existing.updated !== arrival.updated){
        existing.updated = arrival.updated;
        entryChanged = true;
    }
    if(existing.title !== arrival.title){
        existing.title = arrival.title;
        entryChanged = true;
    }
    if(existing.content !== arrival.content){
        existing.content = arrival.content;
        entryChanged = true;
    }
    if(existing.url !== arrival.url){
        existing.url = arrival.url;
        entryChanged = true;
    }
    var exCategories = existing.categories;
    var arCategories = arrival.categories;

    if(exCategories.length !== arCategories.length){
        existing.categories = arCategories;
        entryChanged = true;
    } else {
        for(var i=0,len=exCategories.length; i<len; i++){
            //if at least one category is different, ovveride whole array.
            if(arCategories.indexOf(exCategories[i]) === -1){
                existing.categories = arCategories;
                entryChanged = true;
                break;
            }
        }
    }

    if(existing.author != arrival.author){
        existing.author = arrival.author;
        entryChanged = true;
    }

    return entryChanged ? existing : null;
};

/**
 * Strip html tags from entries.
 * @param {Array} inserts
 * @param {Array} updates
 * @returns {undefined}
 */
rss.sync.sanitize = function(inserts, updates){
    
    var reg = /<.+?>/gim;
    var reg_whitespaces = /\s{2,}/gim;
    
    for(var i=0, len=inserts.length; i<len; i++){
        inserts[i].text = inserts[i].content.replace(reg, ' ');
        inserts[i].text = inserts[i].text.replace(reg_whitespaces, ' ');
    }
    
    rss.sync.update(inserts, updates);
};



rss.sync.update = function(inserts, updates){
    if(inserts.length > 0 || updates.length > 0){
        rss.db.insertPosts(inserts, updates, function(){
            rss.db.close();
            self.postMessage({'inserted':inserts.length, feedid: rss.sync.currentFeed.id});
        });
    } else {
        rss.db.close();
        self.postMessage({'inserted':0, feedid: rss.sync.currentFeed.id});
    }
};