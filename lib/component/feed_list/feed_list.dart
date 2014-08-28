library rssapp.component.feedlist;
import 'dart:html';
import 'package:angular/angular.dart';
import '../../service/query_service.dart';
import '../../service/dbstructures.dart';

@Component(
    selector: 'feed-list',
    templateUrl: 'packages/rss_app/component/feed_list/feed_list.html',
    cssUrl: const [
      'packages/rss_app/component/common.css',
      'packages/rss_app/component/feed_list/feed_list.css'
    ],
    publishAs: 'cmp')
class FeedListComponent {
  
  List<Feed> get feeds => queryService.feeds;
  int get selected => queryService.currentFeedId;
  String get selectArea => queryService.currentPostsArea;
  int unreadCount = 0;
  
  QueryService queryService;
  
  FeedListComponent(QueryService this.queryService);
  
  void onStarChange(MouseEvent e, Feed feed){
    e.preventDefault();
    feed.starred = !feed.starred;
    queryService.updateFeed(feed).catchError((_){
      feed.starred = !feed.starred;
    });
  }
  
  void removeFeed(feed){
    queryService.removeFeed(feed).catchError((e){
      //TODO: notify error
      print("Error removing feed: $e");
    }).then((_){
      queryService.feeds.remove(feed);
    });
  }
}