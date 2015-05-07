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
importScripts('utils.js');

self.onmessage = function(e) {
    var opt = e.data;
    console.log('WELCOME TO THE IMAGE_SERVICE.js WORKER. NOW WE BEGIN WITH COMMAND: ' + opt.cmd);
    switch(opt.cmd){
        case 'images':
            rss.image.updateImages();
        break;
    }
};

/**
 * Rss app namespace
 * @type rss
 */
var rss = rss || {};
/**
 * Image service namespace.
 * @type type
 */
rss.image = {};

rss.image.updateImages = function() {
    rss.db.getUnread()
    .then(rss.image._syncImages)
    .then(function(){
        self.postMessage({'cmd': 'images'});
    });
};
rss.image._syncImages = function(entries) {
    return new Promise(function(resolve, reject) {
        
        function run(){
            console.log('Calling run.');
            var entry; 
            while(!entry){
                entry = entries.shift();
                if(!entry){
                    resolve();
                    return;
                }
                if(entry.imageUrl){
                    entry = null;
                    continue;
                }
            }
            
            var url = rss.utils.extractImageUrl(entry.content);
            if(!url){
                run();
                return;
            }
            rss.utils.loadImageBlob(url)
            .then(function(imageUrl){
                console.log('The image url: ' +imageUrl);
                if(imageUrl === null){
                    return null;
                }
                entry.imageUrl = imageUrl;
                return rss.db.insertPosts([], [entry]);
            })
            .then(function(){
                console.log('Calling another round.');
                run();
            }).catch(function(e){
                console.log('Error occured but calling another round.');
                console.error(e);
                run();
            });
        }
        run();
    });
};