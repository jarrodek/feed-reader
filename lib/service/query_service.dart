library rssapp.service.queryservice;

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import 'database.dart';
import 'dbstructures.dart';

@Injectable()
class QueryService {
  final Http _http;
  final RssDatabase db; 
  Future _loaded;
  List<Feed> feeds = [];
  List<FeedEntry> unread = [];
  List<FeedEntry> currentPosts = [];
  
  QueryService(Http this._http, RssDatabase this.db) {
    
    _loaded = Future.wait([_loadFeeds()])
    .then((_) => _getFeedIds())
    .then((List<int> ids) => this.db.countPosts(ids))
    .then((Map<int,int> res) => _mapPostsCounters(res))
    .then((_) => this.db.listUnread())
    .then((List<FeedEntry> unread) => this.unread = unread)
    .then((_) => _mapUnreadCounters())
    .then((_) => getPosts('unread'))
    .then((List<FeedEntry> posts) => currentPosts = posts);
    
  }
  
  List<int> _getFeedIds(){
    List<int> ids = new List<int>();
    this.feeds.forEach((Feed feed) => ids.add(feed.id));
    return ids;
  }
  
  void _mapPostsCounters(Map<int,int> counters){
    this.feeds.forEach((Feed feed) => counters.containsKey(feed.id) ? feed.postsCounter = counters[feed.id] : 0);
  }
  void _mapUnreadCounters(){
    this.unread.forEach((FeedEntry entry) {
      //TODO: check it's performance. If it returns event loop it will not be efficient.
      Feed feed = getFeed(entry.feedid);
      if(feed == null) return;
      feed.unreadCounter++;
    });
  }
  Feed getFeed(int feedId){
    if(feeds == null) return null;
    
    for(int i=0, len=feeds.length; i<len; i++){
      if(feeds[i].id == feedId){
        return feeds[i];
      }
    }
    return null;
  }
  
  Future<List<FeedEntry>> getPosts(String feedId){
    
    switch(feedId){
      case 'unread':
        return this.db.listUnread().then((List<FeedEntry> posts) => currentPosts = posts);
      case 'starred':
        return this.db.listStarred().then((List<FeedEntry> posts) => currentPosts = posts);
      case 'all':
        return this.db.listAll().then((List<FeedEntry> posts) => currentPosts = posts);
      default:
        return this.db.getPosts(feedId).then((List<FeedEntry> posts) => currentPosts = posts);
    }
  }
  
  ///Load all feeds data.
  Future _loadFeeds(){
    return this.db.getFeeds().then((List<Feed> feeds) => this.feeds = feeds);
  }
  
  Future addFeed(String url){
    return this.db.addFeed(url).then((Feed feed){
      if(this.feeds == null){
        this.feeds = [];
      }
      this.feeds.add(feed);
    });
  }
  
  
}
