library rssapp.component.addfeedheader;

import 'dart:html';

import 'package:angular/angular.dart';

import '../../service/query_service.dart';
import '../../service/dbstructures.dart';

@Component(
    selector: 'add-feed-header', 
    templateUrl: 'packages/rss_app/component/add_feed_header/add_feed_header.html', 
    publishAs: 'cmp',
    useShadowDom: false,
    map: const {
      'on-refresh-feeds': '&onRefreshFeeds'
    })
class AddFeedHeqaderComponent {
  
  QueryService queryService;
  Router router;
  
  bool showAddFeed = false;
  bool addingFeed = false;
  bool refreshingFeeds = false;
  String feedAddUrl = "";
  int get currentPostId => queryService.currentPostId;
  
  bool get addFeedDisabled => !(feedAddUrl.startsWith("http://") || feedAddUrl.startsWith("https://"));
  
  List<FeedEntry> get entries => queryService.currentPosts;
  bool get hasUnread{
    for(int i=0,len=entries.length; i<len; i++){
      if(entries[i].unread == true){
        return true;
      }
    }
    return false;
  }
  
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
    return (feedEntryPosition + 1);
  }
  
  bool get readingPost => queryService.currentPostId > 0;
  
  bool get hasNextEntry{
    if(currentPostsLength-1 >= feedEntryPosition+1){
      return true;
    }
    return false;
  }
  
  bool get hasPrevEntry{
    if(feedEntryPosition == 0){
      return false;
    }
    return true;
  }

  AddFeedHeqaderComponent(QueryService this.queryService, Router this.router);

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
  
  
  int _nextEntryId(){
    if(currentPostsLength-1 >= feedEntryPosition+1){
      return entries[feedEntryPosition+1].id;
    }
    return 0;
  }
  int _prevEntryId(){
    if(feedEntryPosition == 0){
      return 0;
    }
    return entries[feedEntryPosition-1].id;
  }
  
  void goToPost(String dir){
    int postId = dir == 'prev' ? _prevEntryId() : _nextEntryId();
    print('$dir post ID: $postId');
    if(postId == 0) return;
    router.gotoUrl('/post/$postId');
  }
  
  dynamic onRefreshFeeds;
  
  void markAllAsRead(){
    queryService.markCurrentAsRead();
  }
  
}
