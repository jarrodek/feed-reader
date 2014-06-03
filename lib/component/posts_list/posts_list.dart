library rssapp.component.postlist;

import 'dart:html';

import 'package:angular/angular.dart';
import '../../service/dbstructures.dart';
import '../../service/query_service.dart';

@Component(
    selector: 'posts-list', 
    templateUrl: 'packages/rss_app/component/posts_list/posts_list.html', 
    //cssUrl: 'packages/rss_app/component/posts_list/posts_list.css', 
    useShadowDom: false,
    publishAs: 'cmp')
class PostsListComponent implements AttachAware {

  @NgAttr('data-source')
  String dataSource;
  
  @NgAttr('data-feed')
  String feedId;

  QueryService queryService;
  RouteProvider routeProvider;
  Router router;
  Map<int, List<FeedEntry>> postsMap = new Map<int, List<FeedEntry>>();
  List<Feed> feeds = new List<Feed>();
  
  int get listLength {
    int res = 5;
    
    if(dataSource != null && dataSource == "feed"){
      if(feeds.first != null && postsMap.containsKey(feeds.first.id)){
        res = postsMap[feeds.first.id].length;
      }
    }
    
    return res;
  }

  PostsListComponent(RouteProvider this.routeProvider, QueryService this.queryService, Router this.router);

  void attach() {
    
    switch (dataSource) {
      case 'unread':
        _getGenericSource('unread');
        break;
      case 'starred':
        _getGenericSource('starred');
        break;
      case 'all':
        _getGenericSource('all');
        break;
      case 'feed':
        String feedId = routeProvider.parameters['feedId'];
        _getFeedSource(feedId);
        break;
      default:
        print('Initialization in PostsListComponent?????');
        break;
    }
  }
  
  void onStarChange(FeedEntry entry){
    queryService.updateEntry(entry).catchError((e){
      window.console.error(e);
    });
  }
  
  void _getFeedSource(String feedId){
    int id;
    try{
      id = int.parse(feedId);
    } catch(e){
      //TODO: report an error.
      window.console.error(e);
      
      return;
    }
    Feed feed = queryService.getFeedById(id);
    if(feed == null){
      // TODO: report an error.
      window.console.error("No feed in response.");
      return;
    }
    feeds.clear();
    feeds.add(feed);
    
    queryService.getPosts(feedId).then((List<FeedEntry> posts) {
      postsMap[feed.id] = new List<FeedEntry>();
      postsMap[feed.id].addAll(posts);
    });
  }
  
  
  
  void _getGenericSource(String source){
    this.queryService.getPosts(source).then((List<FeedEntry> posts) {
      Map<int, List<FeedEntry>> _postsMap = new Map<int, List<FeedEntry>>();
      posts.forEach((FeedEntry entry) {
        Feed feed = this.queryService.feeds.firstWhere((Feed f) => f.id == entry.feedid);
        if(feed == null) return;
        
        if(!feeds.contains(feed)){
          feeds.add(feed);
        }
        
        if(!_postsMap.containsKey(feed.id)){
          _postsMap[feed.id] = new List<FeedEntry>();
        }
        _postsMap[feed.id].add(entry);
      });
      postsMap = _postsMap;
    });
  }
  
  void readPost(postId){
    
    this.router.gotoUrl("/post/$postId");
    print(postId);
  }

}
