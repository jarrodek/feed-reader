library rssapp.component.listarticle;


import 'package:angular/angular.dart';
import '../../service/dbstructures.dart';
import '../../service/query_service.dart';
import '../../service/analytics.dart';

@Component(selector: 'list-article', 
    templateUrl: 'packages/rss_app/component/lists/list-article.html', 
    cssUrl: 'packages/rss_app/component/lists/list-article.css',
    map: const {
      'article': '<=>entry'
    }, 
    publishAs: 'Article')
class ListArticleComponent {

  FeedEntry entry;
  QueryService queryService;
  Router router;
  AnalyticsService analytics;
  
  String get articleUri => '/post/${Uri.encodeComponent(entry.entryid)}';

  ListArticleComponent(this.queryService, this.router, this.analytics);
  
  void onStarChange() {
    queryService.changeStar(!entry.starred, entry: entry).catchError((e) {
      entry.starred = !entry.starred;
      print(e);
    });
    String mark = !entry.starred == true ? 'starred' : 'unstarred';
    analytics.trackEvent('Entry', 'Star', mark);
  }
  
  void readPost(postId) {
    this.router.gotoUrl(articleUri);
  }
}
