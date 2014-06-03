library rssapp.component.feedlist;

import 'package:angular/angular.dart';
import '../../service/dbstructures.dart';

@Component(
    selector: 'feed-list',
    templateUrl: 'packages/rss_app/component/feed_list/feed_list.html',
    cssUrl: 'packages/rss_app/component/feed_list/feed_list.css',
    publishAs: 'cmp')
class FeedListComponent {
  
  @NgOneWay('feeds')
  List<Feed> feeds;
  
  @NgTwoWay('selected')
  String selected;
  
  @NgOneWay('unread-count')
  int unreadCount;
  
}