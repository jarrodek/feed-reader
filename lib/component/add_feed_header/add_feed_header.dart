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
  FeedEntry currentFeed;
  
  StreamSubscription<RouteStartEvent> routerListener;
  
  bool get addFeedDisabled => !(feedAddUrl.startsWith("http://") || feedAddUrl.startsWith("https://"));
  int get currentPostsLength => queryService.currentPosts.length;
  int get currentPostsIndex{
    try{
      currentFeed = queryService.currentPosts.firstWhere((FeedEntry f) => f.id == currentPostId);
    } catch(e){
      //window.console.error(e);
      return 0;
    }
    return queryService.currentPosts.indexOf(currentFeed) + 1;
  }
  FeedEntry get nextEntry{
    var pos = queryService.currentPosts.indexOf(currentFeed);
    if(pos == -1){
      return null;
    }
    if(queryService.currentPosts.length >= pos+1){
      return queryService.currentPosts[pos+1];
    }
    return null;
  }
  
  FeedEntry get prevEntry{
    var pos = queryService.currentPosts.indexOf(currentFeed);
    if(pos == -1 || pos == 0){
      return null;
    }
    return queryService.currentPosts[pos-1];
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
        print('postId: $postId');
        currentPostId = int.parse(url.substring(6));
        print('currentPostId: $currentPostId');
      } catch(e){
        currentPostId = 0;
      }
    } else {
      readingPost = false;
    }
    
  }
  
  void goToPost(String dir){
    FeedEntry post = dir == 'prev' ? prevEntry : nextEntry;
    
    print('aaaaaaaaaaaa. Dir: $dir, post: $post');
    
    if(post == null) return;
    router.gotoUrl('/post/${post.id}');
  }
  
  void detach(){
    if(routerListener == null) return;
    routerListener.cancel();
  }
}
