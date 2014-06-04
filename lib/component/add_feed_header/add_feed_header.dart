library rssapp.component.addfeedheader;

import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';

import '../../service/query_service.dart';
import '../../service/dbstructures.dart';

@Component(
    selector: 'add-feed-header', 
    templateUrl: 'packages/rss_app/component/add_feed_header/add_feed_header.html', 
    publishAs: 'cmp',
    useShadowDom: false)
class AddFeedHeqaderComponent extends DetachAware {
  
  QueryService queryService;
  Router router;
  
  bool showAddFeed = false;
  bool addingFeed = false;
  bool refreshingFeeds = false;
  bool readingPost = false;
  String feedAddUrl = "";
  int currentPostId = 0;
  
  
  StreamSubscription<RouteStartEvent> routerListener;
  
  bool get addFeedDisabled => !(feedAddUrl.startsWith("http://") || feedAddUrl.startsWith("https://"));
  
  List<FeedEntry> get entries => queryService.currentPosts;
  
  ///Get posts list current size.
  int get currentPostsLength => entries.length;
  ///Result currently selected feed entry 0-based position in the list.
  int feedEntryPosition = 0;
  ///Result currently selected feed entry 1-based position in the list.
  int get currentPostsIndex{
    if(currentPostId == 0){
      return 0;
    }
    bool found = false;
    feedEntryPosition = 0;
    for(int len = currentPostsLength; feedEntryPosition<len; feedEntryPosition++){
      if(entries[feedEntryPosition].id == currentPostId){
        found = true;
        break;
      }
    }
    if(!found){
      return 0;
    }
    return feedEntryPosition + 1;
  }
  
  FeedEntry get nextEntry{
    if(currentPostsLength-1 >= feedEntryPosition+1){
      return entries[feedEntryPosition+1];
    }
    return null;
  }
  
  FeedEntry get prevEntry{
    if(feedEntryPosition == 0){
      return null;
    }
    return entries[feedEntryPosition-1];
  }

  AddFeedHeqaderComponent(QueryService this.queryService, Router this.router){
    routerListener = router.onRouteStart.listen(_handleRouterChange);
  }

  void addFeed() {

    if (addFeedDisabled) {
      //TODO: error handling.
      return;
    }
    
    showAddFeed = false;
    addingFeed = true;

    queryService.addFeed(feedAddUrl).then((_) {
      feedAddUrl = '';
      addingFeed = false;
      //TODO: refresh feed.
    }).catchError((error) {
      addingFeed = false;
      window.console.error(error);
    });
  }
  
  void _handleRouterChange(RouteStartEvent e){
    if(e == null || e.uri == null) return;
    var url = e.uri;
    
    if(url.startsWith('/post/')){
      readingPost = true;
      try{
        var postId = url.substring(6);
        currentPostId = int.parse(url.substring(6));
      } catch(e){
        currentPostId = 0;
      }
    } else {
      readingPost = false;
    }
    
  }
  
  void goToPost(String dir){
    FeedEntry post = dir == 'prev' ? prevEntry : nextEntry;
    if(post == null) return;
    router.gotoUrl('/post/${post.id}');
  }
  
  void detach(){
    if(routerListener == null) return;
    routerListener.cancel();
  }
}
