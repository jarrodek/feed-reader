library rssapp.component.feedlist;
import 'dart:html';
import 'package:angular/angular.dart';
import '../../service/query_service.dart';
import '../../service/dbstructures.dart';
import '../../service/analytics.dart';

@Component(selector: 'feed-list', templateUrl: 'packages/rss_app/component/feed_list/feed_list.html', cssUrl: const ['packages/rss_app/component/common.css', 'packages/rss_app/component/feed_list/feed_list.css'], publishAs: 'cmp')
class FeedListComponent {

  List<Feed> get feeds => queryService.feeds;
  int get selected => queryService.feedId;
  String get selectArea => queryService.currentEntriesArea;
  int unreadCount = 0;

  QueryService queryService;
  AnalyticsService analytics;

  FeedListComponent(this.queryService, this.analytics);

  void onStarChange(MouseEvent e, Feed feed) {
    e.preventDefault();
    queryService.changeStar(!feed.starred, feed: feed).catchError((_) {
      feed.starred = !feed.starred;
    });
    String mark = !feed.starred == true ? 'starred' : 'unstarred';
    analytics.trackEvent('Feed', 'Star', mark);
  }

  void removeFeed(feed) {
    queryService.removeFeed(feed).catchError((e) {
      //TODO: notify error
      print("Error removing feed: $e");
    });
    
    analytics.trackEvent('Feed', 'remove', '1');
  }

  void clearFeed(Feed feed) {
    queryService.clearFeed(feed).catchError((e) {
      //TODO: notify error
      print("Error clearing feed: $e");
    });
    analytics.trackEvent('Feed', 'clear', 'feed list menu clear');
  }
  
  String starClass(Feed feed) => !feed.starred ? 'star-outline' : 'star';
}
