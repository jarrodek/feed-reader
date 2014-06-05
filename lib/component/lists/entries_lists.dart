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
    templateUrl: 'packages/rss_app/component/lists/entries_lists.html',  
    useShadowDom: false,
    publishAs: 'cmp',
    map: const {
      'data-source': '@dataSource'
    })
class EntriesListComponent implements AttachAware {

  String dataSource;  
  QueryService queryService;
  Router router;
  
  List<FeedEntry> get entries => queryService.currentPosts;
  List<Feed> get feeds => queryService.feeds;
  
  int listLength = 5;
  
  EntriesListComponent(QueryService this.queryService, Router this.router);

  void attach() {
//    
//    switch (dataSource) {
//      case 'unread':
//      case 'starred':
//      case 'all':
//        _getGenericSource(dataSource);
//        break;
//      default:
//        window.console.error("Undefined data-source attribute for <entries-lists>: $dataSource");
//    }
  }
  
  bool hasPosts(int feedId){
    if(entries == null) return false;
    Feed feedObject;
    try{
      entries.firstWhere((FeedEntry entry) => entry.feedid == feedId);
      return true;
    } catch(e){
      return false;
    }
    return false;
  }
  
  void onStarChange(FeedEntry entry){
    queryService.updateEntry(entry).catchError((e){
      window.console.error(e);
    });
  }
  
//  void _getGenericSource(String source){
//    this.queryService.getPosts(source).then((_) {
//      print('Posts loaded.');
//    });
//  }
  
  void readPost(postId){
    this.router.gotoUrl("/post/$postId");
  }

}
