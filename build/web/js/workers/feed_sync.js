importScripts('../app_db.js');

self.onmessage = function(e) {
    syncPosts.sync(e.data);
    
    rss_app.onerror = function(e){
        throw e.message;
    };
    
//    self.postMessage(feed);
};

var syncPosts = {
    'dbposts': [],
    'newFeed': [],
    'currentFeed': null,
    'sync': function(options){
        
        syncPosts.newFeed = options.newFeed;
        syncPosts.currentFeed = options.currentFeed;
        syncPosts.syncFeed();
        
    },
    
    'syncFeed': function() {
        var currentFeed = syncPosts.currentFeed;
        var feedNewData = syncPosts.newFeed;
        var feedChanged = false;
        
        if(currentFeed.feedid !== feedNewData.feedid){
            currentFeed.feedid = feedNewData.feedid;
            feedChanged = true;
        }
        if(currentFeed.title !== feedNewData.title){
            currentFeed.title = feedNewData.title;
            feedChanged = true;
        }
        if(currentFeed.subtitle !== feedNewData.subtitle){
            currentFeed.subtitle = feedNewData.subtitle;
            feedChanged = true;
        }
        if(currentFeed.author !== feedNewData.author){
            currentFeed.author = feedNewData.author;
            feedChanged = true;
        }
        if(currentFeed.categories !== feedNewData.categories){
            currentFeed.categories = feedNewData.categories;
            feedChanged = true;
        }
        if(currentFeed.etag !== feedNewData.etag){
            currentFeed.etag = feedNewData.etag;
            feedChanged = true;
        }
        if(currentFeed.updated !== feedNewData.updated){
            currentFeed.updated = feedNewData.updated;
            feedChanged = true;
        }
        if(currentFeed.pageurl !== feedNewData.pageurl){
            currentFeed.pageurl = feedNewData.pageurl;
            feedChanged = true;
        }
        if(feedChanged){
            rss_app.indexedDB.updateFeed(currentFeed, function(){
                console.log('Feed updated', currentFeed);
            });
        }
        
        rss_app.indexedDB.getFeedPosts(syncPosts.currentFeed.id, function(posts){
            syncPosts.dbposts = posts;
            syncPosts.synContent();
        });
        
    },
    
    'synContent': function(){
        var oldSize = syncPosts.dbposts.length;
        var inserts = [];
        var updates = [];
        for(var i=0, len=syncPosts.newFeed.entries.length; i<len; i++){
            var newEntry = syncPosts.newFeed.entries[i];
            var existing = null;
            for(var j=0; j<oldSize; j++){
                if(newEntry.entryid === syncPosts.dbposts[j].entryid){
                    existing = syncPosts.dbposts[j];
                    break;
                }
            }
            if(existing === null){
                newEntry['new'] = 1;
                newEntry['unread'] = 1;
                newEntry['feedid'] = syncPosts.currentFeed.id;
                newEntry['starred'] = 0;
                inserts[inserts.length] = newEntry;
            } else {
                var toUpdate = syncPosts._checkEntry(existing, newEntry);
                if(toUpdate !== null){
                    updates[updates.length] = toUpdate;
                }
            }
        }
        syncPosts.update(inserts, updates);
    },
    
    '_checkEntry': function(existing, arrival){
        
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
    },
    
    'update': function(inserts, updates){
        if(inserts.length > 0 || updates.length > 0){
            rss_app.indexedDB.insertPosts(inserts, updates, function(){
                rss_app.indexedDB.close();
                self.postMessage({'inserted':inserts.length});
            });
        } else {
            rss_app.indexedDB.close();
            self.postMessage({'inserted':0});
        }
    }
};
