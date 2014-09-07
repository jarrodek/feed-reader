library rssapp.service.queryservice;

import 'dart:async';

import 'package:angular/angular.dart';

import 'database.dart';
import 'dbstructures.dart';

@Injectable()
class QueryService {
  final Http _http;
  final RssDatabase db;
  Future _loaded;

  ///List of all feeds in the app
  List<Feed> feeds = [];

  ///An database ID of currently selected feed.
  int feedId;

  ///List of all currently displaed entries
  List<FeedEntry> entries = [];

  ///And database ID of currently selected entry.
  String entryId = null;

  ///The map where the key is the [Feed.id] and the value is a number of unread messages for this feed.
  Map<int, int> unreadMap = new Map<int, int>();

  ///Number of all unread entrys.
  int get unreadCount {
    int cnt = 0;
    unreadMap.forEach((int feed, int _cnt) => cnt += _cnt);
    return cnt;
  }

  String currentEntriesArea = null;

  QueryService(Http this._http, RssDatabase this.db) {
    _loaded = Future.wait([loadFeeds()]); //, countUnreads()
  }

  ///Load all feeds data.
  Future loadFeeds() {
    return this.db.getFeeds().then((List<Feed> feeds) => this.feeds = feeds);
  }
  
  void clearState(){
    entries.clear();
    feedId = null;
    entryId = null;
    currentEntriesArea = null;
  }

  /// Count unread [FeedEntry] in the datastore.
  int countUnread(int feedId, [bool forceDb = false]) {
    if (unreadMap.containsKey(feedId) && !forceDb) {
      return unreadMap[feedId];
    } else {
      unreadMap[feedId] = 0;
      this.db.countUnread(feedId).then((int cnt) {
        unreadMap[feedId] = cnt;
      });
    }
    return 0;
  }
  ///Force count unread [FeedEntry] for given [Feed] represented by [feedId].
  void _revalideteUnread(int feedId) {
    this.db.countUnread(feedId).then((int cnt) {
      unreadMap[feedId] = cnt;
    });
  }


  /// Populate current entries list with entries for given [Feed] as it's databases [feedId]
  Future populateEntries(String feedId) {
    switch (feedId) {
      case 'unread':
        return this.db.listUnread().then(_sortEntries).then((List<FeedEntry> entriesList) => entries = entriesList);
      case 'starred':
        return this.db.listStarred().then(_sortEntries).then((List<FeedEntry> entriesList) => entries = entriesList);
      case 'all':
        return this.db.listAll().then(_sortEntries).then((List<FeedEntry> entriesList) => entries = entriesList);
      default:
        return this.db.getEntries(int.parse(feedId), from: 0, to: 25).then(_sortEntries).then((List<FeedEntry> entriesList) => entries = entriesList);
    }
  }
  ///[page] parameter is 1-based.
  Future<int> feedEntries(int feedId, {count: null, page: null}) {

    int from = null;
    int to = null;
    if (count != null) {
      if (page == null) {
        page = 1;
      }
      if (page > 0) {
        page--;
      }
      from = count * page;
      to = from + count;
    }

    return this.db.getEntries(feedId, from: from, to: to).then(_sortEntries).then((List<FeedEntry> entriesList) {
      if (entriesList == null) {
        return 0;
      }
      entries.addAll(entriesList);
      return entriesList.length;
    });
  }

  /**
   * Sort entries in current feed.
   * Entries should be sorted by special field "created" genereated
   * by the backgroud page as a timestamp of "published".
   * If, for some reason, this field doeas not exists
   * fallback will be used (parsing "published" field).
   */
  List<FeedEntry> _sortEntries(List<FeedEntry> entries) {
    entries.sort((FeedEntry a, FeedEntry b) {
      if (a.createtime == null || b.createtime == null) {
        DateTime d1, d2;
        try {
          d1 = DateTime.parse(a.published);
        } catch (e) {
          return -a.entryid.compareTo(b.entryid);
        }
        try {
          d2 = DateTime.parse(b.published);
        } catch (e) {
          return -a.entryid.compareTo(b.entryid);
        }
        return -d1.compareTo(d2);
      }
      return -a.createtime.compareTo(b.createtime);
    });
    return entries;
  }



  /// Update the [FeedEntry] object.
  Future _updateEntry(FeedEntry entry) {
    return this.db.updateEntry(entry).then((_) {
      /// If the change was "set read" it should recalculate unread.
      return entry;
    });
  }
  ///Update the [Feed] object.
  Future _updateFeed(Feed feed) {
    return this.db.updateFeed(feed).then((_) {
      print(feeds.contains(feed));
    });
  }

  ///Add a new [Feed] to the datastore.
  Future addFeed(String url) {
    return this.db.addFeed(url).then((Feed feed) {
      if (this.feeds == null) {
        this.feeds = [];
      }
      this.feeds.add(feed);
    });
  }
  ///Delete feed from database.
  Future removeFeed(feed) {
    return this.db.removeFeed(feed).then((_) {
      this.feeds.remove(feed);
      return true;
    });
  }
  /**
   * In oposite to [getFeedById] it is a synchronius function
   * for look for an feed by it's databases [feedId] in
   * curent list of feeds.
   * This function will not look for [Feed] in datastore. 
   */
  Feed getFeed(int feedId) {
    if (feeds == null) return null;

    for (int i = 0,
        len = feeds.length; i < len; i++) {
      if (feeds[i].id == feedId) {
        return feeds[i];
      }
    }
    return null;
  }
  /** 
   * Set the [entry] [read] or not. 
   * This function will recalculate number of unread entries.
   */
  Future setEntryRead(FeedEntry entry, bool read) {
    if (entry.unread == !read) {
      return new Future.value(entry);
    }
    entry.unread = !read;
    var result = null;
    return this.db.updateEntry(entry).then((entry) => result = entry)/*.then((_) => countUnreads())*/.then((_) {
      _revalideteUnread(entry.feedid);
      return result;
    });
  }

  /// Get the [Feed] by it's database [id]
  Future<Feed> getFeedById(int id) {
    return _loaded.then((_) {
      try {
        return this.feeds.firstWhere((Feed f) => f.id == id);
      } catch (e) {
        return null;
      }
    });

  }

  /// Get the [FeedEntry] by it's [id]
  Future<FeedEntry> getEntry(String id) {
    for (int i = 0,
        len = entries.length; i < len; i++) {
      if (entries[i].entryid == id) {
        return new Future.value(entries[i]);
      }
    }

    return this.db.getEntry(id).then((FeedEntry entry) => entries.add(entry));
  }

  /// Change state of the "starred" for feed or entry.
  Future changeStar(bool starred, {FeedEntry entry: null, Feed feed: null}) {
    if (entry != null) {
      entry.starred = starred;
      return _updateEntry(entry);
    } else if (feed != null) {
      feed.starred = starred;
      return _updateFeed(feed);
    }
    return null;
  }

  /// Mark all curently loaded entries as read.
  void markCurrentAsRead() {
    List _entries = [];
    entries.forEach((FeedEntry entry) {
      if (!entry.unread) {
        return;
      }
      entry.unread = false;
      _entries.add(entry);
    });

    db.updateEntries(_entries).then((_) {
      if (feedId != null && feedId != 0) {
        _revalideteUnread(feedId);
      } else {
        feeds.forEach((Feed f) => _revalideteUnread(f.id));
      }
    });


  }
  ///Get list of [FeedEntry] for specified by [tag] category.
  Future<List<FeedEntry>> entriesByTag(String tag) {
    return db.getByCategory(tag).then(_sortEntries).then((List<FeedEntry> entriesList) => entries = entriesList);
  }

  Future clearFeed(Feed feed) {
    return db.clearEntries(feed.id).then((_) {
      if (feedId == feed.id) {
        entries.clear();
        unreadMap[feed.id] = 0;
      }
    });
  }
}
