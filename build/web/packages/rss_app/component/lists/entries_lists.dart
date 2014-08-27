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
    publishAs: 'EntriesList',
    cssUrl: const [
      'packages/rss_app/component/lists/entries_lists.css'
    ],
    map: const {
      'data-source': '@dataSource'
    })
class EntriesListComponent {

  String dataSource;  
  QueryService queryService;
  Router router;
  
  List<FeedEntry> get entries => queryService.currentPosts;
  List<Feed> get feeds => queryService.feeds;
  
  int listLength = 5;
  
  bool hasPostsInView = false;
  
  EntriesListComponent(QueryService this.queryService, Router this.router);
  
  bool hasPosts(int feedId){
    if(entries == null) return false;
    Feed feedObject;
    try{
      entries.firstWhere((FeedEntry entry) => entry.feedid == feedId);
      hasPostsInView = true;
      return true;
    } catch(e){
      return false;
    }
    return false;
  }
  
  void onStarChange(FeedEntry entry){
    entry.starred = !entry.starred;
    queryService.updateEntry(entry).catchError((e){
      //TODO: error report.
      window.console.error(e);
    }).then((FeedEntry entry){
      
    });
  }
  
  void readPost(postId){
    this.router.gotoUrl("/post/$postId");
  }

}
