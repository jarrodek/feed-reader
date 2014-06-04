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
  List<FeedEntry> currentPosts = [];
  Map<int, int> unreadMap = new Map<int, int>();
  
  
  String _currentFeedId;
  set currentFeedId(String id) {
    print('currentFeedId in QueryService $id');
    _currentFeedId = id; 
  }
  String get currentFeedId => _currentFeedId;
  
  int _unreadCount;
  int get unreadCount {
    if(_unreadCount == null){
      return 0;
    }
    return _unreadCount;
  }
  
  
  
  QueryService(Http this._http, RssDatabase this.db) {
    _loaded = Future.wait([_loadFeeds(), _countUnreads()]);
  }
  
  ///Load all feeds data.
  Future _loadFeeds(){
    return this.db.getFeeds().then((List<Feed> feeds) => this.feeds = feeds);
  }
  ///Count number of unread posts.
  Future _countUnreads(){
    return this.db.countUnread(null).then((int cnt) => _unreadCount = cnt);
  }
  
  
  int countUnread(int feedId){
    if(unreadMap.containsKey(feedId)){
      return unreadMap[feedId];
    }
    this.db.countUnread(feedId).then((int cnt) => unreadMap[feedId] = cnt);
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
        return this.db.getPosts(int.parse(feedId)).then((List<FeedEntry> posts) => currentPosts = posts);
    }
  }
  
  
  
  Future addFeed(String url){
    return this.db.addFeed(url).then((Feed feed){
      if(this.feeds == null){
        this.feeds = [];
      }
      this.feeds.add(feed);
    });
  }
  
  Future updateEntry(FeedEntry entry){
    return this.db.updateEntry(entry).then((_){
      //print(currentPosts.contains(entry));
    });
  }
  
  Future setEntryRead(FeedEntry entry){
    if(!entry.unread){
      return new Future.value(entry);
    }
    
    
    entry.unread = false;
    var result = null;
    return this.db.updateEntry(entry)
        .then((entry) => result = entry)
        .then((_) => this.db.listUnread())
        .then((_){
          return result;
        });
  }
  
  
  Feed getFeedById(int id){
    try{
      return this.feeds.firstWhere((Feed f) => f.id == id);
    } catch(e){
      return null;
    }
  }
  
  Future<FeedEntry> getPost(int id){
    for(int i=0, len=currentPosts.length; i<len; i++){
      if(currentPosts[i].id == id){
        return new Future.value(currentPosts[i]);
      }
    }
    
    return this.db.getPost(id).then((FeedEntry entry) => currentPosts.add(entry));
  }
  
}
