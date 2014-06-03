library rssapp.service.database;

import 'dart:async';
import 'dart:html';
import 'dart:indexed_db';

import 'package:angular/angular.dart';

import 'dbstructures.dart';


@Injectable()
class RssDatabase {
  static final int DB_VERSION = 2;
  static final String FEEDS_STORE = "feeds";
  static final String POSTS_STORE = "posts";

  Database db;
  Future _loaded;

  RssDatabase() {
    _loaded = Future.wait([_loadDatabase()]);
  }

  Future _loadDatabase() {
    return window.indexedDB.open('rss_feeds', version: DB_VERSION, onUpgradeNeeded: _initializeDatabase).then((Database db) => this.db = db);
  }

  void _initializeDatabase(VersionChangeEvent e) {
    Database db = (e.target as Request).result;
    if (db.objectStoreNames.contains(FEEDS_STORE)) {
      db.deleteObjectStore(FEEDS_STORE);
    }
    if (db.objectStoreNames.contains(POSTS_STORE)) {
      db.deleteObjectStore(POSTS_STORE);
    }
    var feedstore = db.createObjectStore(FEEDS_STORE, autoIncrement: true, keyPath: 'id');
    feedstore.createIndex('feedid', 'feedid', unique: true, multiEntry: false);
    feedstore.createIndex('url', 'url', unique: true, multiEntry: false);

    var poststore = db.createObjectStore(POSTS_STORE, autoIncrement: true, keyPath: 'id');
    poststore.createIndex('entryid', 'entryid', unique: true, multiEntry: false);
    poststore.createIndex('categories', 'categories', unique: false, multiEntry: true);
    poststore.createIndex('feedid', 'feedid', unique: false, multiEntry: false);
    poststore.createIndex('unread', 'unread', unique: false, multiEntry: false);
    poststore.createIndex('starred', 'starred', unique: false, multiEntry: false);
  }

  Future<List<Feed>> getFeeds() => db == null ? _loaded.then((_) => _getFeeds()) : _getFeeds();

  Future<List<Feed>> _getFeeds() {
    var completer = new Completer();
    Transaction transaction = this.db.transaction([FEEDS_STORE], "readonly");
    ObjectStore objectStore = transaction.objectStore(FEEDS_STORE);
    List<Feed> entries = [];
    Stream<CursorWithValue> cursors = objectStore.openCursor(autoAdvance: true).asBroadcastStream();
    cursors.listen((cursor) {
      Feed feed = new Feed.fromDb(cursor.value);
      entries.add(feed);
    });

    transaction.completed.then((_) {
      completer.complete(entries);
    });

    return completer.future;
  }
  /**
   * Add new [Feed] into database
   */
  Future addFeed(String url) => db == null ? _loaded.then((_) => _addFeed(url)) : _addFeed(url);
  Future<Feed> _addFeed(String url) {
    var completer = new Completer();
    Transaction transaction = this.db.transaction([FEEDS_STORE], "readwrite");
    ObjectStore objectStore = transaction.objectStore(FEEDS_STORE);
    Feed feed = new Feed(url);
    var map = null;
    try {
      map = feed.toJson();
    } catch (e) {
      window.console.error(e);
      throw "Unable to add a feed.";
    }
    objectStore.add(map).then((addedKey) {
      feed.id = addedKey;
    }).catchError((error) {
      window.console.error('[Method] Unable insert new feed');
    });


    transaction.completed.then((_) {
      completer.complete(feed);
    });
    transaction.onError.listen((e) {
      window.console.error('[Transaction] Unable insert new feed');
    });
    return completer.future;
  }

  Future<List<FeedEntry>> listUnread() => db == null ? _loaded.then((_) => _listPosts("unread")) : _listPosts("unread"); 
  Future<List<FeedEntry>> listStarred() => db == null ? _loaded.then((_) => _listPosts("starred")) : _listPosts("starred");
  Future<List<FeedEntry>> listAll() => db == null ? _loaded.then((_) => _listPosts()) : _listPosts();
  
  Future<List<FeedEntry>> _listPosts([String source = null]) {
    var completer = new Completer<List<FeedEntry>>();
    Transaction transaction = this.db.transaction([POSTS_STORE], "readonly");
    ObjectStore objectStore = transaction.objectStore(POSTS_STORE);
    
    Stream<CursorWithValue> cursors;
    
    if(source != null){
      var index = objectStore.index(source);
      var range = new KeyRange.only(1);
      cursors = index.openCursor(range:range,autoAdvance:true).asBroadcastStream();
    } else {
      cursors = objectStore.openCursor(autoAdvance:true).asBroadcastStream();
    }
    
    List<FeedEntry> entries = new List<FeedEntry>();
    cursors.listen((cursor) {
      FeedEntry feed = new FeedEntry.fromDb(cursor.value);
      entries.add(feed);
    });

    transaction.completed.then((_) {
      completer.complete(entries);
    });

    return completer.future;
  }
  

  Future<Map<int, int>> countPosts(List<int> feedIds) => db == null ? _loaded.then((_) => _countPosts(feedIds)) : _countPosts(feedIds);
  Future<Map<int, int>> _countPosts(List<int> feedIds) {
    var completer = new Completer<Map<int, int>>();

    var ops = [];
    Map<int, int> result = new Map<int, int>();
    feedIds.forEach((int feedId) {
      Transaction transaction = this.db.transaction([POSTS_STORE], "readonly");
      ObjectStore objectStore = transaction.objectStore(POSTS_STORE);
      var index = objectStore.index("feedid");
      var range = new KeyRange.only(feedId);
      var fut = index.count(range).then((int cnt) => result[feedId] = cnt);
      ops.add(fut);
    });

    Future.wait(ops).then((_) => completer.complete(result));

    return completer.future;
  }
  /**
   * Get posts list for specified by [feedIdExt] feed. [feedIdExt] is a feed's ID from server's response. 
   * 
   */
  Future<List<FeedEntry>> getPosts(String feedIdExt) => db == null ? _loaded.then((_) => _getPosts(feedIdExt)) : _getPosts(feedIdExt);
  Future<List<FeedEntry>> _getPosts(String feedIdExt) {
    return _getFeeds().then((List<Feed> feeds) => _getFeed(feeds, feedIdExt)).then((Feed feed) => _getPostsForFeed(feed.id));
  }
  Feed _getFeed(List<Feed> feeds, feedIdExt) {
    for (int i = 0,
        len = feeds.length; i < len; i++) {
      if (feeds[i].feedid == feedIdExt) {
        return feeds[i];
      }
    }
    return null;
  }
  Future<List<FeedEntry>> _getPostsForFeed(int feedId) {
    var completer = new Completer<List<FeedEntry>>();
    
    Transaction transaction = this.db.transaction([POSTS_STORE], "readonly");
    ObjectStore objectStore = transaction.objectStore(POSTS_STORE);
    Index index = objectStore.index("feedid");
    KeyRange range = new KeyRange.only(feedId);
    
    List<FeedEntry> entries = new List<FeedEntry>();
    
    Stream<CursorWithValue> cursors = index.openCursor(range:range,autoAdvance:true).asBroadcastStream();
    cursors.listen((cursor) {
      FeedEntry feed = new FeedEntry.fromDb(cursor.value);
      entries.add(feed);
    });

    transaction.completed.then((_) {
      completer.complete(entries);
    });
    return completer.future;
  }
}
