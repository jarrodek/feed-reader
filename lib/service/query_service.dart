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
  
  int currentFeedId;
  int currentPostId = 0;
  int unreadCount = 0;
  
  String currentPostsArea = 'unread';
  
  QueryService(Http this._http, RssDatabase this.db) {
    _loaded = Future.wait([_loadFeeds(), _countUnreads()]);
  }
  
  ///Load all feeds data.
  Future _loadFeeds(){
    return this.db.getFeeds().then((List<Feed> feeds) => this.feeds = feeds);
  }
  ///Count number of unread posts.
  Future _countUnreads(){
    return this.db.countUnread(null).then((int cnt) => unreadCount = (cnt == null ? 0 : cnt))
        .catchError((e) => window.console.error(e));
  }
  
  
  int countUnread(int feedId){
    if(unreadMap.containsKey(feedId)){
      return unreadMap[feedId];
    } else {
      unreadMap[feedId] = 0;
      this.db.countUnread(feedId).then((int cnt) {
        unreadMap[feedId] = cnt;
      });
    }
    return 0;
  }
  
  void _revalideteUnread(int feedId){
    this.db.countUnread(feedId).then((int cnt) {
      unreadMap[feedId] = cnt;
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
  
  Future getPosts(String feedId){
    
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
      print(currentPosts.contains(entry));
    });
  }
  
  Future updateFeed(Feed feed){
    return this.db.updateFeed(feed).then((_){
      print(feeds.contains(feed));
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
      .then((_) => _countUnreads())
      .then((_){
        _revalideteUnread(entry.feedid);
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
  
  void markCurrentAsRead(){
    var tasks = [];
    currentPosts.forEach((FeedEntry entry){
      if(!entry.unread){
        return;
      }
      entry.unread = false;
      Future f = this.db.updateEntry(entry);
      tasks.add(f);
    });
    Future.wait(tasks)
    .then((_) => _countUnreads())
    .then((_){
      if(currentFeedId != null && currentFeedId != 0){
        return _revalideteUnread(currentFeedId);
      } else {
        return new Future.value(null);
      }
    });
  }
  
  Future markFeedStarred(bool starred, int feedId){
    if(!feeds.contains(feedId)){
      throw "No such feed: $feedId";
    }
    
    Feed f = feeds[feedId];
    if(f.starred){
      return new Future.value(true);
    } 
    
    //TODO: mark feed as starred,
   
  }
  
}
