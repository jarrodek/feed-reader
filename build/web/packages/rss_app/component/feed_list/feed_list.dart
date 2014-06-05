library rssapp.component.feedlist;

import 'package:angular/angular.dart';
import '../../service/query_service.dart';
import '../../service/dbstructures.dart';

@Component(
    selector: 'feed-list',
    templateUrl: 'packages/rss_app/component/feed_list/feed_list.html',
    cssUrl: 'packages/rss_app/component/feed_list/feed_list.css',
    publishAs: 'cmp')
class FeedListComponent {
  
  List<Feed> get feeds => queryService.feeds;
  String get selected => queryService.currentFeedId;
  int unreadCount = 0;
  
  QueryService queryService;
  
  FeedListComponent(QueryService this.queryService);
  
}