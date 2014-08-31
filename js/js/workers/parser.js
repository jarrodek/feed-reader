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

importScripts('tinyxmlsax.js');
importScripts('tinyxmlw3cdom.js');
importScripts('structures.js');

self.onmessage = function(e) {

    var feed = rss.parser.parse(e.data);
    
    self.postMessage(feed);
};

var rss = rss || {};
rss.parser = {};
rss.parser.parse = function(data) {
    var parser = new DOMImplementation();
    var xml = parser.loadXML(data);
    var _parser = rss.parser.recognize(xml);
    if (_parser === null) {
        throw "Unrecognized feed";
    }
    return _parser.parse();
};
/**
 * Recognize feed type.
 * Either it can be a RSS feed or an Atom feed.
 * This function return proper parser or null if feed is unknown.
 * @returns {Object|null} Parser object or null if unknown.
 */
rss.parser.recognize = function(xml) {
    if (!xml)
        return null;
    if (xml.getElementsByTagName('rss').length > 0) {
        //return new RssParser();
        return null;
    }
    if (xml.getElementsByTagName('feed').length > 0) {
        return new AtomParser(xml);
    }
    return null;
};





function AtomParser(xml) {
    this.xml = xml;
    this.feed = new Feed();
}
/**
 * Parse Atom feed and return an object.
 * @returns {Object}
 */
AtomParser.prototype.parse = function() {
    var feed = this.xml.getElementsByTagName('feed');
    var children = feed.item(0).childNodes;
    for (var i = 0, len = children.length; i < len; i++) {
        var node = children.item(i);
        this._parseNode(node);
    }
    return this.feed.toJson();
};

AtomParser.prototype._parseNode = function(node) {
    switch (node.nodeName) {
        case 'id':
            this.feed.feedid = node.childNodes.item(0).nodeValue.toString();
            break;
        case 'updated':
            this.feed.updated = node.childNodes.item(0).nodeValue.toString();
            break;
        case 'title':
            this.feed.title = node.childNodes.item(0).nodeValue.toString();
            break;
        case 'subtitle':
            this.feed.subtitle = node.childNodes.item(0).nodeValue.toString();
            break;
        case 'author':
            this.feed.author = this._parseAuthor(node);
            break;
        case 'openSearch:totalResults':
            try {
                this.feed.totalItems = parseInt(node.childNodes.item(0).nodeValue.toString());
            } catch (e) {
            }
            break;
        case 'entry':
            this.feed.entries.push(this._parseEntry(node));
            break;
        case 'category':
            var term = node.attributes.getNamedItem('term');
            if(term){
                this.feed.categories.push(term.nodeValue.toString());
            }
            //this.feed.categories.push(node.childNodes.item(0).nodeValue.toString());
            break;
        case 'link':
            var rel = node.attributes.getNamedItem('rel');
            if(!rel) return;
            if(rel.nodeValue.toString() !== "alternate") return;
            var type = node.attributes.getNamedItem('type');
            if(!type) return;
            if(type.nodeValue.toString() !== "text/html") return;
            var href = node.attributes.getNamedItem('href');
            if(!href) return;
            this.feed.pageurl = href.nodeValue.toString();
            break;
    }
};
AtomParser.prototype._parseAuthor = function(node) {
    var author = new FeedAuthor();

    for (var i = 0, len = node.childNodes.length; i < len; i++) {
        var a_node = node.childNodes.item(i);
        switch (a_node.nodeName) {
            case 'name':
                author.name = a_node.childNodes.item(0).nodeValue.toString();
                break;
            case 'email':
                author.email = a_node.childNodes.item(0).nodeValue.toString();
                break;
            case 'uri':
                author.url = a_node.childNodes.item(0).nodeValue.toString();
                break;
            case 'gd:image':
                var src = a_node.attributes.getNamedItem('src');
                if(src){
                    var src = src.nodeValue.toString();
                    if(src.indexOf('//') === 0){
                        src = 'https:' + src;
                    }
                    author.image.src = src;
                }
                var width = a_node.attributes.getNamedItem('width');
                var height = a_node.attributes.getNamedItem('height');
                if(width){
                    author.image.width = width.nodeValue.toString();
                }
                if(height){
                    author.image.height = height.nodeValue.toString();
                }
                break;
        }

    }

    return author;
};
AtomParser.prototype._parseEntry = function(node) {
    var entry = new FeedEntry();

    for (var i = 0, len = node.childNodes.length; i < len; i++) {
        var e_node = node.childNodes.item(i);
        switch (e_node.nodeName) {
            case 'id':
                entry.entryid = e_node.childNodes.item(0).nodeValue.toString();
                break;
            case 'updated':
                entry.updated = e_node.childNodes.item(0).nodeValue.toString();
                break;
            case 'published':
                entry.published = e_node.childNodes.item(0).nodeValue.toString();
                break;
            case 'title':
                entry.title = e_node.childNodes.item(0).nodeValue.toString();
                break;
            case 'content':
            case 'summary':
                entry.content = e_node.childNodes.item(0).nodeValue.toString();
                break;
            case 'author':
                entry.author = this._parseAuthor(e_node);
                break;
            case 'category':
                var term = e_node.attributes.getNamedItem('term');
                if(term){
                    entry.categories.push(term.nodeValue.toString());
                }
                //entry.categories.push(e_node.childNodes.item(0).nodeValue.toString());
                break;
            case 'link':
                var attr = e_node.attributes;
                var map = {};
                for (var j = 0, attrLen = attr.length; j < attrLen; j++) {
                    var _a = attr.item(j);
                    map[_a.nodeName] = _a.nodeValue;
                }
                if ('rel' in map) {
                    if (map['rel'].toString() === 'alternate') {
                        entry.url = map['href'].toString();
                    }
                }
                break;
            case 'media:thumbnail':
                var src = e_node.attributes.getNamedItem('src');
                if(src){
                    var src = src.nodeValue.toString();
                    if(src.indexOf('//') === 0){
                        src = 'https:' + src;
                    }
                    entry.thumbnail.src = src;
                }
                var width = e_node.attributes.getNamedItem('width');
                var height = e_node.attributes.getNamedItem('height');
                if(width){
                    entry.thumbnail.width = width.nodeValue.toString();
                }
                if(height){
                    entry.thumbnail.height = height.nodeValue.toString();
                }
                break;
        }
    }

    return entry;
};


function RssParser(xml) {
    this.xml = xml;
}

