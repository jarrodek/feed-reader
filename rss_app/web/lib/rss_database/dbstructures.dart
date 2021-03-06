library rssapp.dbstructures;

import 'package:polymer/polymer.dart';
import 'dart:collection';

class Feed extends Object with Observable {
  /// Internal database ID
  int id;
  /// ID of the feed (from the feed).
  @observable String feedid;
  /// Channel's title
  @observable String title;
  /// Channel's subtitle
  @observable String subtitle;
  /// Channel's update time (as string)
  @observable String updated;
  /// Feed author
  @observable FeedAuthor author;
  /// Corresponding page URL.
  @observable String pageurl;
  /// Feed URL (feed's source url)
  String url;
  /// Etag header
  @observable String etag;
  /// Feed's categories.
  @observable List<String> categories = toObservable([]);

  @observable String get display => title == null ? url : title;
  int _entriesCounter = 0;
  /// Get number of entries in this feed. 
  /// This field is not saved into database. 
  @observable int get entriesCounter => _entriesCounter;
  ///Sent a number of posts available for this feed. 
  set entriesCounter(int i) => _entriesCounter = i;
  
  int _unreadCounter = null;
  @observable int get unreadCounter => _unreadCounter;
  set unreadCounter(int i) => _unreadCounter = i;
  ///Test if this feed has unread items.
  @observable bool get hasUnread => _unreadCounter > 0;
  @observable bool starred = false;
  /// Runtime flag, set when new items arrive when program is running
  @observable bool newItems = false;
  
  Feed(this.url);

  Feed.fromDb(LinkedHashMap data) {
    this.id = data['id'];
    this.feedid = data['feedid'];
    this.title = data['title'];
    this.subtitle = data['subtitle'];
    this.updated = data['updated'];
    this.pageurl = data['pageurl'];
    this.url = data['url'];
    this.etag = data['etag'];
    this.categories = data['categories'];
    if (data.containsKey('author')) {
      if (data['author'] != null) {
        this.author = new FeedAuthor.fromDb(data['author']);
      }
    }
    this.starred = data['starred'] == null ? true : data['starred'] == 1 ? true : false;
  }

  Map toJson() {
    
    Map data = {
      'feedid': this.feedid,
      'title': this.title,
      'subtitle': this.subtitle,
      'updated': this.updated,
      'pageurl': this.pageurl,
      'url': this.url,
      'etag': this.etag,
      'categories': this.categories == null || categories.isEmpty ? [] : this.categories,
      'starred': this.starred == null ? 0 : (this.starred ? 1 : 0),
    };
    
    if (this.id != null) {
      data['id'] = this.id;
    }
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    return data;
  }

  String toString() {
    StringBuffer sb = new StringBuffer();
    sb.write("Feed[ ");
    sb.write("id(db)=$id, ");
    sb.write("id(feed)=$feedid, ");
    sb.write("title=$title, ");
    sb.write("subtitle=$subtitle, ");
    sb.write("updated=$updated, ");
    sb.write("author=$author, ");
    sb.write("categories=$categories, ");
    sb.write("pageurl=$pageurl, ");
    sb.write("url(feed source)=$url, ");
    sb.write("etag=$etag");
    sb.write("]");
    return sb.toString();
  }
}

class FeedEntry extends Object with Observable {
  ///Database ID
  //int id;
  ///Feed's database ID
  int feedid;
  ///Entry ID (from the feed)
  String entryid;
  ///Publication date as string
  String published;
  ///Timestamp generated from [published].
  int createtime = 0;
  ///Update time date as string
  String updated;
  ///Entry's title
  String title;
  ///Entry's content
  String content;
  ///Stripped content data.
  String text;
  ///Reference URL
  String url;
  
  ///The image url founded in the entry content.
  String imageUrl;
  ///Entry's author
  FeedAuthor author;
  ///Entry's categories
  List<String> categories = [];
  ///In databse this field is called "new"!
  @observable bool newitem = false;
  ///True if item has not been read.
  @observable bool unread = false;
  @observable bool starred = false;

  FeedEntry.fromDb(LinkedHashMap data) {
    if(data == null){
      throw "Can't restore DB object from null object.";
    }
    //this.id = data['id'];
    this.feedid = data['feedid'];
    this.entryid = data['entryid'];
    this.published = data['published'];
    this.createtime = data['createtime'];
    this.updated = data['updated'];
    this.title = data['title'];
    this.content = data['content'];
    this.text = data['text'];
    this.url = data['url'];
    if (data.containsKey('author')) {
      if (data['author'] != null) {
        this.author = new FeedAuthor.fromDb(data['author']);
      }
    }
    this.categories = data['categories'];
    this.imageUrl = data['imageUrl'];
    
    this.newitem = data['new'] == null ? true : data['new'] == 1 ? true : false;
    this.unread = data['unread'] == null ? true : data['unread'] == 1 ? true : false;
    this.starred = data['starred'] == null ? true : data['starred'] == 1 ? true : false;
  }

  Map toJson() {
    Map data = {
      'feedid': this.feedid,
      'entryid': this.entryid,
      'published': this.published,
      'createtime': this.createtime,
      'updated': this.updated,
      'title': this.title,
      'content': this.content,
      'text': this.text,
      'url': this.url,
      'imageUrl': this.imageUrl,
      'categories': this.categories,
      'newitem': this.newitem == null ? 1 : this.newitem ? 1 : 0,
      'unread': this.unread == null ? 1 : this.unread ? 1 : 0,
      'starred': this.starred == null ? 0 : this.starred ? 1 : 0,
    };
//    if (this.id != null) {
//      data['id'] = this.id;
//    }
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    return data;
  }


  String toString() {
    StringBuffer sb = new StringBuffer();
    sb.write("FeedEntry[ ");
//    sb.write("id(db)=$id, ");
    sb.write("id(feed-db)=$feedid, ");
    sb.write("id(entry)=$entryid, ");
    sb.write("newitem=$newitem, ");
    sb.write("unread=$unread, ");
    sb.write("published=$published, ");
    sb.write("updated=$updated, ");
    sb.write("title=$title, ");
    sb.write("text=$text");
    sb.write("content=$content, ");
    sb.write("url=$url, ");
    sb.write("author=$author, ");
    sb.write("categories=$categories");
    sb.write("]");
    return sb.toString();
  }
}

class FeedAuthor {
  String name;
  String email;
  String url;
  FeedAuthorImage image;
  FeedAuthor(this.name, [this.url, this.email, this.image]);

  FeedAuthor.fromDb(data) {
    this.name = data['name'];
    this.email = data['email'];
    this.url = data['url'];
    if (data.containsKey('image')) {
      if (data['image'] != null) {
        this.image = new FeedAuthorImage.fromDb(data['image']);
      }
    }
  }

  Map toJson() {
    Map data = {
      'name': this.name,
      'email': this.email,
      'url': this.url
    };
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    return data;
  }

  String toString() {
    StringBuffer sb = new StringBuffer();
    sb.write("FeedAuthor[ ");
    sb.write("name=$name, ");
    sb.write("email=$email, ");
    sb.write("image=$image, ");
    sb.write("url=$url");
    sb.write("]");
    return sb.toString();
  }
}

class FeedAuthorImage {
  var width;
  var height;
  String src;

  FeedAuthorImage(this.src, [this.width, this.height]);

  FeedAuthorImage.fromDb(data) {
    this.width = data['width'];
    this.height = data['height'];
    this.src = data['src'];
  }

  Map toJson() {
    Map data = {
      'width': this.width,
      'height': this.height,
      'src': this.src
    };
    return data;
  }

  String toString() {
    StringBuffer sb = new StringBuffer();
    sb.write("FeedAuthorImage[ ");
    sb.write("src=$src, ");
    sb.write("width=$width, ");
    sb.write("height=$height");
    sb.write("]");
    return sb.toString();
  }
}
