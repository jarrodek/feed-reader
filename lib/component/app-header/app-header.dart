library rssapp.component.addfeedheader;

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:rss_app/service/events_observer.dart';
import '../../service/communication.dart';

import '../../service/query_service.dart';
import '../../service/dbstructures.dart';

@Component(
    selector: 'app-header', 
    templateUrl: 'packages/rss_app/component/app-header/app-header.html', 
    publishAs: 'cmp',
    cssUrl: const [
      'packages/rss_app/component/common.css',
      'packages/rss_app/component/app-header/app-header.css'
    ])
class AppHeaderComponent {
  
  QueryService _queryService;
  AppComm communication;
  Router router;
  
  bool showAddFeed = false;
  bool addingFeed = false;
  bool get refreshingFeeds => communication.updatingFeeds;
  bool get hasFeeds => _queryService.feeds.length > 0;
  String feedAddUrl = "";
  String get entryId => _queryService.entryId;
  bool get addFeedDisabled => !(feedAddUrl.startsWith("http://") || feedAddUrl.startsWith("https://"));
  
  List<FeedEntry> get entries => _queryService.entries;
  bool get hasUnread{
    if(entries.length == 0) return false;
    for(int i=0,len=entries.length; i<len; i++){
      if(entries[i].unread == true){
        return true;
      }
    }
    return false;
  }
  
  ///Get entries list current size.
  int get currentEntriesLength => entries.length;
  ///Result currently selected feed entry 0-based position in the list.
  int feedEntryPosition = 0;
  ///Result currently selected feed entry 1-based position in the list.
  int get currentEntryIndex{
    
    if(entryId == 0){
      return 0;
    }
    
    bool found = false;
    feedEntryPosition = 0;
    for(int len = currentEntriesLength; feedEntryPosition<len; feedEntryPosition++){
      if(entries[feedEntryPosition].entryid == entryId){
        found = true;
        break;
      }
    }
    if(!found){
      return 0;
    }
    
    return (feedEntryPosition + 1);
  }
  
  bool get readingEntry => _queryService.entryId != null;
  
  bool get hasNextEntry{
    if(currentEntriesLength-1 >= feedEntryPosition+1){
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
  ///TODO: Add arrows support.
  AppEvents appEvents;
  
  AppHeaderComponent(this._queryService, this.router, this.appEvents, this.communication);

  void addFeed() {

    if (addFeedDisabled) {
      //TODO: error handling.
      return;
    }
    
    showAddFeed = false;
    addingFeed = true;

    _queryService.addFeed(feedAddUrl).then((_) {
      feedAddUrl = '';
      addingFeed = false;
      communication.refreshFeeds();
    }).catchError((error) {
      addingFeed = false;
      window.console.error(error);
    });
  }
  
  
  String _nextEntryId(){
    if(currentEntriesLength-1 >= feedEntryPosition+1){
      return entries[feedEntryPosition+1].entryid;
    }
    return "";
  }
  String _prevEntryId(){
    if(feedEntryPosition == 0){
      return "";
    }
    return entries[feedEntryPosition-1].entryid;
  }
  
  void goToEntry(String dir){
    String entryId = dir == 'prev' ? _prevEntryId() : _nextEntryId();
    entryId = Uri.encodeComponent(entryId);
    print('$dir entry ID: $entryId');
    if(entryId == 0) return;
    router.gotoUrl('/post/$entryId');
  }
  
  void onRefreshFeeds(){
    communication.refreshFeeds();
  }
  
  void markAllAsRead(){
    _queryService.markCurrentAsRead();
  }
  
}
