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

  List<Feed> feeds = [];
  List<FeedEntry> currentPosts = [];
  Map<int, int> unreadMap = new Map<int, int>();

  int currentFeedId;
  String currentPostId = null;
  int unreadCount = 0;

  String currentPostsArea = 'unread';

  QueryService(Http this._http, RssDatabase this.db) {
    _loaded = Future.wait([loadFeeds(), countUnreads()]);
  }

  ///Load all feeds data.
  Future loadFeeds() {
    return this.db.getFeeds().then((List<Feed> feeds) => this.feeds = feeds);
  }
  ///Count number of unread posts.
  Future countUnreads() {
    return this.db.countUnread(null).then((int cnt) => unreadCount = (cnt == null ? 0 : cnt)).catchError((e) => print(e));
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
  
  
  /// Populate current posts list with posts for given [Feed] as it's databases [feedId]
  Future populatePosts(String feedId) {
    switch (feedId) {
      case 'unread':
        return this.db.listUnread().then(_sortPosts).then((List<FeedEntry> posts) => currentPosts = posts);
      case 'starred':
        return this.db.listStarred().then(_sortPosts).then((List<FeedEntry> posts) => currentPosts = posts);
      case 'all':
        return this.db.listAll().then(_sortPosts).then((List<FeedEntry> posts) => currentPosts = posts);
      default:
        return this.db.getPosts(int.parse(feedId)).then(_sortPosts).then((List<FeedEntry> posts) => currentPosts = posts);
    }
  }
  
  /**
   * Sort posts in current feed.
   * Posts should be sorted by special field "created" genereated
   * by the backgroud page as a timestamp of "published".
   * If, for some reason, this field doeas not exists
   * fallback will be used (parsing "published" field).
   */
  List<FeedEntry> _sortPosts(List<FeedEntry> posts) {
    posts.sort((FeedEntry a, FeedEntry b) {
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
      return a.createtime.compareTo(b.createtime);
    });
    return posts;
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
    return this.db.removeFeed(feed).then((_){
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
   * This function will recalculate number of unread posts.
   */
  Future setEntryRead(FeedEntry entry, bool read) {
    if (entry.unread == !read) {
      return new Future.value(entry);
    }
    entry.unread = !read;
    var result = null;
    return this.db.updateEntry(entry).then((entry) => result = entry).then((_) => countUnreads()).then((_) {
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
  Future<FeedEntry> getPost(String id) {
    for (int i = 0,
        len = currentPosts.length; i < len; i++) {
      if (currentPosts[i].entryid == id) {
        return new Future.value(currentPosts[i]);
      }
    }

    return this.db.getPost(id).then((FeedEntry entry) => currentPosts.add(entry));
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

  /// Mark all curently loaded posts as read.
  void markCurrentAsRead() {
    var tasks = [];
    currentPosts.forEach((FeedEntry entry) {
      if (!entry.unread) {
        return;
      }
      entry.unread = false;
      Future f = this.db.updateEntry(entry);
      tasks.add(f);
    });
    Future.wait(tasks).then((_) => countUnreads()).then((_) {
      if (currentFeedId != null && currentFeedId != 0) {
        return _revalideteUnread(currentFeedId);
      } else {
        return new Future.value(null);
      }
    });
  }

}
