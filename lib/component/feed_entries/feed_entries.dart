library rssapp.component.postlist;

import 'dart:html';

import 'package:angular/angular.dart';
import '../../service/dbstructures.dart';
import '../../service/query_service.dart';

@Component(
    selector: 'feed-entries', 
    templateUrl: 'packages/rss_app/component/feed_entries/feed_entries.html',
    useShadowDom: false,
    publishAs: 'cmp')
class FeedEntriesComponent implements AttachAware {
  
  QueryService queryService;
  RouteProvider routeProvider;
  Router router;
  int get feedId => queryService.currentFeedId;
  
  List<FeedEntry> get entries => queryService.currentPosts;
  Feed get feed {
    if(feedId == null) return null;
    for(var i=0, len=queryService.feeds.length; i<len; i++){
      if(queryService.feeds[i].id == feedId){
        return queryService.feeds[i];
      }
    }
    return null;
  }
    
  FeedEntriesComponent(RouteProvider this.routeProvider, QueryService this.queryService, Router this.router);

  void attach() {
//    String feedId = routeProvider.parameters['feedId'];
//    _getFeedSource(feedId);
  }
  
  void onStarChange(FeedEntry entry){
    queryService.updateEntry(entry).catchError((e){
      window.console.error(e);
    });
  }
  
//  void _getFeedSource(String _feedId){
//    
//    try{
//      feedId = int.parse(_feedId);
//    } catch(e){
//      //TODO: report an error.
//      window.console.error(e);
//      return;
//    }
//    Feed feed = queryService.getFeedById(feedId);
//    if(feed == null){
//      // TODO: report an error.
//      window.console.error("No feed in response.");
//      return;
//    }
//    
//    queryService.getPosts(feedId.toString()).then((_) {
//      //TODO: finish loading.
//    });
//  }
  
  void readPost(postId){
    this.router.gotoUrl("/post/$postId");
  }

}
