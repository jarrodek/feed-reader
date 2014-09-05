library rssapp.component.tagentries;

import 'package:angular/angular.dart';
import '../../service/dbstructures.dart';
import '../../service/query_service.dart';
import '../../service/analytics.dart';

@Component(
    selector: 'tag-entries', 
    templateUrl: 'packages/rss_app/component/tag_entries/tag_entries.html',
    cssUrl: const [
      'packages/rss_app/component/tag_entries/tag_entries.css',
      'packages/rss_app/component/feed-common.css'
    ],
    publishAs: 'Tag')
class TagEntriesComponent {
  
  QueryService queryService;
  String tag;
  List<FeedEntry> get entries => queryService.entries;
  
  TagEntriesComponent(QueryService this.queryService, RouteProvider routeProvider, AnalyticsService analytics){
    tag = routeProvider.parameters['tag'];
    tag = Uri.decodeComponent(tag);
    queryService.entriesByTag(tag);
    
    analytics.trackPageview('Reading tag');
  }
  
}
