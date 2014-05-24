library rssapp.component.postlist;

import 'dart:html';

import 'package:angular/angular.dart';
import '../service/dbstructures.dart';
import '../service/query_service.dart';

@Component(selector: 'posts-list', templateUrl: 'packages/rss_app/component/posts_list.html', cssUrl: 'packages/rss_app/component/posts_list.css', publishAs: 'cmp')
class PostsListComponent implements AttachAware {

  @NgAttr('data-source')
  String dataSource;

  QueryService queryService;
  RouteProvider routeProvider;
  Map<Feed, List<FeedEntry>> postsMap = new Map<Feed, List<FeedEntry>>();
  List<Feed> get feeds => postsMap.keys.toList();

  PostsListComponent(RouteProvider this.routeProvider, QueryService this.queryService);

  void attach() {
    
    switch (dataSource) {
      case 'unread':
        _getGenericSource('unread');
        break;
      case 'starred':
        _getGenericSource('starred');
        break;
      case 'all':
        _getGenericSource('all');
        break;
      case 'feed':
        String feedId = routeProvider.parameters['feedId'];
        print('Get posts for feed: $feedId');
        break;
      default:
        print('Initialization in PostsListComponent?????');
        break;
    }
  }
  
  void _getGenericSource(String source){
    this.queryService.getPosts(source).then((List<FeedEntry> posts) {
      posts.forEach((FeedEntry entry) {
        Feed feed = this.queryService.feeds.firstWhere((Feed f) => f.id == entry.feedid);
        if(feed == null) return;
        if(!postsMap.containsKey(feed)){
          postsMap[feed] = new List<FeedEntry>();
        }
        postsMap[feed].add(entry);
      });
    });
  }

}
