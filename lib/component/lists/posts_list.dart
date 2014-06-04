library rssapp.component.lists;

import 'dart:html';

import 'package:angular/angular.dart';
import '../../service/dbstructures.dart';
import '../../service/query_service.dart';

/**
 * Class responsible for displaying posts list for "Unread", "Starred" and "All items" sections.
 * 
 */

@Component(
    selector: 'entries-lists', 
    templateUrl: 'packages/rss_app/component/lists/lists.html',  
    useShadowDom: false,
    publishAs: 'cmp',
    map: const {
      'dataSource': '@dataSource'
    })
class EntriesListComponent implements AttachAware {

  String dataSource;  
  QueryService queryService;
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

  EntriesListComponent(QueryService this.queryService, Router this.router);

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
    }
  }
  
  void onStarChange(FeedEntry entry){
    queryService.updateEntry(entry).catchError((e){
      window.console.error(e);
    });
  }
  
  void _getGenericSource(String source){
    this.queryService.getPosts(source).then((_) {
      
      
      
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
  }

}
