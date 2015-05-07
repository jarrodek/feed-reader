library rssapp.database;

import 'dart:async';
import 'dart:html';
import 'dart:indexed_db';

import 'package:polymer/polymer.dart';

import 'dbstructures.dart';

@CustomTag('rss-database')
class RssDatabase extends PolymerElement {

  static final int DB_VERSION = 6;
  static final String FEEDS_STORE = "feeds";
  static final String ENTRIES_STORE = "posts";
  Database db;
  Future _loaded;

  RssDatabase.created() : super.created() {
    _loaded = Future.wait([_loadDatabase()]);
  }

  Future<Database> _loadDatabase() async {
    if(this.db != null) return this.db;
    Database db = await window.indexedDB.open('rss_feeds', version: DB_VERSION, onUpgradeNeeded: _initializeDatabase);
    db.onClose.listen((e){
      this.db = null;
    });
    this.db = db;
    return db;
  }

  void _initializeDatabase(VersionChangeEvent e) {
    Database db = (e.target as Request).result;

    if (db.objectStoreNames.contains(FEEDS_STORE)) {
      db.deleteObjectStore(FEEDS_STORE);
    }
    if (db.objectStoreNames.contains(ENTRIES_STORE)) {
      db.deleteObjectStore(ENTRIES_STORE);
    }
    var feedstore = db.createObjectStore(FEEDS_STORE, autoIncrement: true, keyPath: 'id');
    feedstore.createIndex('feedid', 'feedid', unique: true, multiEntry: false);
    feedstore.createIndex('url', 'url', unique: true, multiEntry: false);

    //var entriesstore = db.createObjectStore(ENTRIES_STORE, autoIncrement: true, keyPath: 'id');
    var entriesstore = db.createObjectStore(ENTRIES_STORE, autoIncrement: false, keyPath: 'entryid');
    //entriesstore.createIndex('entryid', 'entryid', unique: true, multiEntry: false);
    entriesstore.createIndex('categories', 'categories', unique: false, multiEntry: true);
    entriesstore.createIndex('feedid', 'feedid', unique: false, multiEntry: false);
    entriesstore.createIndex('unread', 'unread', unique: false, multiEntry: false);
    entriesstore.createIndex('starred', 'starred', unique: false, multiEntry: false);
    entriesstore.createIndex('unread, feedid', ['unread', 'feedid'], unique: false);
  }
  
  /// Get a list of all feeds from the store.
  Future<List<Feed>> getFeeds() async {
    var completer = new Completer();
    var db = await _loadDatabase();
    Transaction transaction = db.transaction([FEEDS_STORE], "readonly");
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
  
  
  Future<Feed> getFeed(int id) async {
    try{
      var db = await _loadDatabase();
      Transaction transaction = db.transaction([FEEDS_STORE], "readonly");
      ObjectStore objectStore = transaction.objectStore(FEEDS_STORE);
      var mapEntry = await objectStore.getObject(id);
      var entry = new Feed.fromDb(mapEntry);
      return entry;
    } catch(e, stack){
      print("DB error: $e, $stack");
      throw e;
    }
  }
  
  
  /**
   * Add new [Feed] into database
   */
  Future<Feed> addFeed(String url) async {
    var completer = new Completer();
    var db = await _loadDatabase();
    Transaction transaction = db.transaction([FEEDS_STORE], "readwrite");
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
  
  
  /// List unread entries.
  Future<List<FeedEntry>> listUnread({int from: null, int to: null}) => _listEntries(mode: "unread", from: from, to: to, sort: true);
  /// List starred entries.
  Future<List<FeedEntry>> listStarred({int from: null, int to: null}) => _listEntries(mode: "starred", from: from, to: to);
  /// list all entreis.
  Future<List<FeedEntry>> listAll({int from: null, int to: null}) => _listEntries(from: from, to: to);
  /// List entries from specified feed.
  Future<List<FeedEntry>> listEntries(int feedId, {int from: null, int to: null}) => _listEntries(feedId: feedId, from: from, to: to);
  
  Future<List<FeedEntry>> listTags(String tag, {int from: null, int to: null}) => _listEntries(tag: tag, from: from, to: to);
  
  
  /**
   * List entries depending on [mode].
   * [mode] can be: 
   *  "unread" - list unread,
   *  "starred" - list starred
   *  "null" - if [feedId] is not provided then it will get all entries.
   * [feedId] - if [mode] is null will display entries for selected feed.
   * [from] and [to] are used for pagination. It is 0-based right and left limit for the query.
   * [sort] - should not be used very ofter. Using it it will cause that the entire datastore will be read to the array, then sorted 
   * and finally right and left limit will be applied. It is useful for "unread" section when unread entries should appear in chronological order.
   * Without it it can't be guaranteed. If [sort] is false and limits are set it will run much quicker because cursor will stop iterating when right limit will be reached.
   */
  Future<List<FeedEntry>> _listEntries({String mode: null, int feedId: null, String tag: null, int from: null, int to: null, bool sort: false}) async {
    final Completer<List<FeedEntry>> completer = new Completer<List<FeedEntry>>();
    
    final List<FeedEntry> entries = new List<FeedEntry>();
    var db = await _loadDatabase();
    final Transaction transaction = db.transaction([ENTRIES_STORE], "readonly");
    final ObjectStore objectStore = transaction.objectStore(ENTRIES_STORE);
    
    Stream<CursorWithValue> cursors;
     
    if (mode != null) {
      Index index = objectStore.index(mode);
      KeyRange range = new KeyRange.only(1);
      cursors = index.openCursor(range: range, autoAdvance: false, direction: "prev").asBroadcastStream();
    } else if(feedId != null){
      Index index = objectStore.index("feedid");
      KeyRange range = new KeyRange.only(feedId);
      cursors = index.openCursor(range: range, autoAdvance: false, direction: "prev").asBroadcastStream();
    } else if(tag != null){
      Index index = objectStore.index("categories");
      KeyRange range = new KeyRange.only(tag);
      cursors = index.openCursor(range: range, autoAdvance: false, direction: "prev").asBroadcastStream();
    } else {
      cursors = objectStore.openCursor(autoAdvance: false, direction: "prev").asBroadcastStream();
    }
    
    int _index_position = 0;
    cursors.listen((cursor) {
      if (!sort && from != null && _index_position < from) {
        _index_position++;
        cursor.next();
        return;
      }
      
      //print('$_index_position: ${cursor.value['entryid']} - ${cursor.value['title']}');
      
      FeedEntry feed = new FeedEntry.fromDb(cursor.value);
      entries.add(feed);
      _index_position++;

      if (!sort && to != null && _index_position >= to) {
        return;
      }

      cursor.next();
    });
    
    
    transaction.completed.then((_) {
      if(sort){
        entries.sort( (FeedEntry e1, FeedEntry e2) => -e1.createtime.compareTo(e2.createtime) );
        if(from != null && to != null){
          var _entries = [];
          for(int i=0,len=entries.length; i<len; i++){
            if(i< from){
              continue;
            }
            if(i >= to){
              break;
            }
            _entries.add(entries[i]);
          }
          entries.clear();
          entries.addAll(_entries);
        }
      }
      
      completer.complete(entries);
    });
    
    return completer.future;
  }
  
  /// Count unread posts for [Feed] for given [feedId]
  Future<int> countUnread([int feedId]) async {
    
    var db = await _loadDatabase();
    Transaction transaction = db.transaction([ENTRIES_STORE], "readonly");
    ObjectStore objectStore = transaction.objectStore(ENTRIES_STORE);

    var index, range;
    if (feedId == null) {
      index = objectStore.index("unread");
      range = new KeyRange.only(1);
    } else {
      index = objectStore.index("unread, feedid");
      range = new KeyRange.only([1, feedId]);
    }

    return index.count(range);
  }

  Future<Map<int, int>> countEntries(List<int> feedIds) async {
    var db = await _loadDatabase();
    var completer = new Completer<Map<int, int>>();
    var ops = [];
    Map<int, int> result = new Map<int, int>();
    feedIds.forEach((int feedId) {
      Transaction transaction = db.transaction([ENTRIES_STORE], "readonly");
      ObjectStore objectStore = transaction.objectStore(ENTRIES_STORE);
      var index = objectStore.index("feedid");
      var range = new KeyRange.only(feedId);
      var fut = index.count(range).then((int cnt) => result[feedId] = cnt);
      ops.add(fut);
    });

    Future.wait(ops).then((_) => completer.complete(result));

    return completer.future;
  }





  Future updateEntry(FeedEntry entry) {
    
    var completer = new Completer();
    Transaction transaction = this.db.transaction([ENTRIES_STORE], "readwrite");
    ObjectStore objectStore = transaction.objectStore(ENTRIES_STORE);

    objectStore.put(entry.toJson()).catchError((error) {
      window.console.error('[Method] Unable update FeedEntry $entry');
    });

    transaction.completed.then((_) {
      completer.complete(entry);
    });
    transaction.onError.listen((e) {
      window.console.error('[Transaction] Unable update FeedEntry');
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<List<FeedEntry>> updateEntries(List<FeedEntry> entries) {
    var completer = new Completer();
    Transaction transaction = this.db.transaction([ENTRIES_STORE], "readwrite");
    ObjectStore objectStore = transaction.objectStore(ENTRIES_STORE);

    entries.forEach((FeedEntry entry) => objectStore.put(entry.toJson()));

    transaction.completed.then((_) {
      completer.complete(entries);
    });
    transaction.onError.listen((e) {
      window.console.error('[Transaction] Unable update FeedEntry');
      completer.completeError(e);
    });
    return completer.future;
  }

  Future updateFeed(Feed feed) {
    //print('[DATASTORE]  updateFeed(...)');

    var completer = new Completer();
    Transaction transaction = this.db.transaction([FEEDS_STORE], "readwrite");
    ObjectStore objectStore = transaction.objectStore(FEEDS_STORE);
    if (feed.id != null) {
      objectStore.put(feed.toJson()).catchError((error) {
        window.console.error('[Method] Unable update Feed');
        window.console.error(error);
      });
    } else {
      objectStore.add(feed.toJson()).catchError((error) {
        window.console.error('[Method] Unable update Feed $feed');
        window.console.error(error);
      });
    }
    transaction.completed.then((_) {
      completer.complete(feed);
    });
    transaction.onError.listen((e) {
      window.console.error('[Transaction] Unable update Feed');
      completer.completeError(e);
    });

    return completer.future;
  }

  Future removeFeed(Feed feed) {
    Transaction transaction = this.db.transaction([FEEDS_STORE], "readwrite");
    ObjectStore objectStore = transaction.objectStore(FEEDS_STORE);
    objectStore.delete(feed.id);
    return transaction.completed.then((_) {
      return true;
    });
  }

  Future<FeedEntry> getEntry(String id) {
    var completer = new Completer<FeedEntry>();

    Transaction transaction = this.db.transaction([ENTRIES_STORE], "readonly");
    ObjectStore objectStore = transaction.objectStore(ENTRIES_STORE);
    objectStore.getObject(id).then((mapEntry) {
      FeedEntry entry = new FeedEntry.fromDb(mapEntry);
      completer.complete(entry);
    });

    return completer.future;
  }
  
  Future clearEntries(int feedId) => _loaded.then((_) {
    var completer = new Completer<List<FeedEntry>>();

    Transaction transaction = this.db.transaction([ENTRIES_STORE], "readwrite");
    ObjectStore objectStore = transaction.objectStore(ENTRIES_STORE);

    Index index = objectStore.index("feedid");
    KeyRange range = new KeyRange.only(feedId);

    Stream<CursorWithValue> cursors = index.openKeyCursor(range: range).asBroadcastStream();
    
    
    cursors.listen((cursor) {
      objectStore.delete(cursor.primaryKey);
      cursor.next();
    });

    transaction.completed.then((_) {
      completer.complete();
    });

    return completer.future;
  });
}
