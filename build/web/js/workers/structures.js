function Feed() {
    this.feedid = null;
    this.title = null;
    this.subtitle = null;
    this.updated = null;
    this.author = null; /* FeedAuthor */
    this.totalItems = -1;
    this.categories = [];
    this.entries = []; /* [FeedEntry] */
    //this._next = null;
    this.etag = null;
    this.pageurl = null;

    this.toJson = function() {
        var entries = [];
        for (var i = 0, len = this.entries.length; i < len; i++) {
            entries[entries.length] = this.entries[i].toJson();
        }
        var author = null;
        if (this.author !== null) {
            author = this.author.toJson();
        }
        
        return {
            'feedid': this.feedid,
            'title': this.title,
            'subtitle': this.subtitle,
            'pageurl': this.pageurl,
            'updated': this.updated,
            'author': author,
            'totalItems': this.totalItems,
            'categories': this.categories,
            'entries': entries,
            'etag': this.etag
        };
    };
}

function FeedAuthor() {
    this.name = null;
    this.email = null;
    this.image = {
        'src': null,
        'width': null,
        'height': null
    };
    this.url = null;

    this.toJson = function() {
        return {
            'name': this.name,
            'email': this.email,
            'image': this.image,
            'url': this.url
        };
    };
}

function FeedEntry() {
    this.entryid = null;
    this.published = null;
    this.updated = null;
    this.title = null;
    this.content = null;
    this.url = null;
    this.author = null; /* FeedAuthor */
    this.categories = [];
    this.thumbnail = {
        'src': null,
        'width': null,
        'height': null
    };
    this['new'] = 1;
    this.unread = 1;
    this.starred = 0;

    this.toJson = function() {
        var author = null;
        if (this.author !== null) {
            author = this.author.toJson();
        }
        return {
            'entryid': this.entryid,
            'published': this.published,
            'updated': this.updated,
            'title': this.title,
            'content': this.content,
            'url': this.url,
            'author': author,
            'categories': this.categories,
            'new': this['new'],
            'unread': this.unread,
            'starred': this.starred
        };
    };
}