library rssapp.component.lists;

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
  
  List<FeedEntry> get entries => queryService.entries;
  List<Feed> get feeds => queryService.feeds;
  
  int listLength = 5;
  
  bool hasPostsInView = false;
  
  EntriesListComponent(QueryService this.queryService);
  
  bool hasPosts(int feedId){
    if(entries == null) return false;
    try{
      entries.firstWhere((FeedEntry entry) => entry.feedid == feedId);
      hasPostsInView = true;
      return true;
    } catch(e){
      return false;
    }
    return false;
  }
  
}
