library rssapp.component.postlist;

import 'package:angular/angular.dart';
import '../../service/dbstructures.dart';
import '../../service/query_service.dart';
import '../../service/analytics.dart';

@Component(
    selector: 'feed-entries', 
    templateUrl: 'packages/rss_app/component/feed_entries/feed_entries.html',
    cssUrl: const [
      'packages/rss_app/component/feed_entries/feed_entries.css'
    ],
    publishAs: 'cmp')
class FeedEntriesComponent {
  
  QueryService queryService;
  int get feedId => queryService.feedId;
  
  List<FeedEntry> get entries => queryService.entries;
  Feed get feed {
    if(feedId == null) return null;
    for(var i=0, len=queryService.feeds.length; i<len; i++){
      if(queryService.feeds[i].id == feedId){
        return queryService.feeds[i];
      }
    }
    return null;
  }
    
  FeedEntriesComponent(QueryService this.queryService, AnalyticsService analytics){
    queryService.loadFeeds();
    
    analytics.trackPageview('Reading user\'s feed');
  }
  
}
