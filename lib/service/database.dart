library rssapp.service.database;

import 'dart:async';
import 'dart:html';
import 'dart:indexed_db';

import 'package:angular/angular.dart';

import 'dbstructures.dart';


@Injectable()
class RssDatabase {
  static final int DB_VERSION = 6;
  static final String FEEDS_STORE = "feeds";
  static final String ENTRIES_STORE = "posts";

  Database db;
  Future _loaded;

  RssDatabase() {
    _loaded = Future.wait([_loadDatabase()]);
  }

  Future _loadDatabase() {
    return window.indexedDB.open('rss_feeds', version: DB_VERSION, onUpgradeNeeded: _initializeDatabase).then((Database db) => this.db = db);
  }

  void _initializeDatabase(VersionChangeEvent e) {
    //print('[DATASTORE] Initialize database. Upgrading to v: $DB_VERSION');
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

  Future<List<Feed>> getFeeds() => db == null ? _loaded.then((_) => _getFeeds()) : _getFeeds();

  Future<List<Feed>> _getFeeds() {
    //print('[DATASTORE] _getFeeds');
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
    //print('[DATASTORE] _addFeed');
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

  Future<List<FeedEntry>> listUnread() => _loaded.then((_) => _listEntries("unread"));
  Future<List<FeedEntry>> listStarred() => _loaded.then((_) => _listEntries("starred"));
  Future<List<FeedEntry>> listAll() => _loaded.then((_) => _listEntries());

  Future<List<FeedEntry>> _listEntries([String source = null]) {

    var completer = new Completer<List<FeedEntry>>();
    Transaction transaction = this.db.transaction([ENTRIES_STORE], "readonly");
    ObjectStore objectStore = transaction.objectStore(ENTRIES_STORE);

    Stream<CursorWithValue> cursors;

    if (source != null) {
      var index = objectStore.index(source);
      var range = new KeyRange.only(1);
      cursors = index.openCursor(range: range, autoAdvance: true, direction: "prev").asBroadcastStream();
    } else {
      cursors = objectStore.openCursor(autoAdvance: true, direction: "prev").asBroadcastStream();
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

  Future<int> countUnread(int feedId) => db == null ? _loaded.then((_) => _countUnread(feedId)) : _countUnread(feedId);
  Future<int> _countUnread(int feedId) {
    //print('[DATASTORE]  _countUnread(int $feedId)');
    Transaction transaction = this.db.transaction([ENTRIES_STORE], "readonly");
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

  Future<Map<int, int>> countEntries(List<int> feedIds) => db == null ? _loaded.then((_) => _countEntries(feedIds)) : _countEntries(feedIds);
  Future<Map<int, int>> _countEntries(List<int> feedIds) {

    var completer = new Completer<Map<int, int>>();
    var ops = [];
    Map<int, int> result = new Map<int, int>();
    feedIds.forEach((int feedId) {
      Transaction transaction = this.db.transaction([ENTRIES_STORE], "readonly");
      ObjectStore objectStore = transaction.objectStore(ENTRIES_STORE);
      var index = objectStore.index("feedid");
      var range = new KeyRange.only(feedId);
      var fut = index.count(range).then((int cnt) => result[feedId] = cnt);
      ops.add(fut);
    });

    Future.wait(ops).then((_) => completer.complete(result));

    return completer.future;
  }
  
  /**
   * Get entries list for specified by [feedId] (feed's database id). 
   * If [from] (inclusive) and [to] (exclusive) are specified, in result the list will contain elements for those indexes.
   * Indexes are 0-based.
   */
  Future<List<FeedEntry>> getEntries(int feedId, {int from:null, int to:null}) => _loaded.then((_) {
    var completer = new Completer<List<FeedEntry>>();

    Transaction transaction = this.db.transaction([ENTRIES_STORE], "readonly");
    ObjectStore objectStore = transaction.objectStore(ENTRIES_STORE);
    Index index = objectStore.index("feedid");
    KeyRange range = new KeyRange.only(feedId);

    List<FeedEntry> entries = new List<FeedEntry>();

    Stream<CursorWithValue> cursors = index.openCursor(range: range, autoAdvance: true, direction: "prev").asBroadcastStream();
    int current = 0;
    cursors.listen((cursor) {
      current++;
      if(from != null && current-1 <from){
        return;
      }
      if(to != null && current-1 > to){
        return;
      }
      
      FeedEntry feed = new FeedEntry.fromDb(cursor.value);
      entries.add(feed);
    });

    transaction.completed.then((_) {
      completer.complete(entries);
    });
    return completer.future;
  });



  Future updateEntry(FeedEntry entry) {
    //print('[DATASTORE]  updateEntry(...)');
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


  /**
   * Get entries for specified by [tag] category. 
   */
  Future<List<FeedEntry>> getByCategory(String tag) => _loaded.then((_) {
    var completer = new Completer<List<FeedEntry>>();

    Transaction transaction = this.db.transaction([ENTRIES_STORE], "readonly");
    ObjectStore objectStore = transaction.objectStore(ENTRIES_STORE);
    Index index = objectStore.index("categories");

    KeyRange range = new KeyRange.only(tag);
    List<FeedEntry> entries = new List<FeedEntry>();
    Stream<CursorWithValue> cursors = index.openCursor(range: range, autoAdvance: true, direction: "prev").asBroadcastStream();
    cursors.listen((cursor) {
      FeedEntry feed = new FeedEntry.fromDb(cursor.value);
      entries.add(feed);
    });
    transaction.completed.then((_) {
      completer.complete(entries);
    });
    return completer.future;
  });

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
