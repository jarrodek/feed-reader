library rssapp.component.listarticle;


import 'package:angular/angular.dart';
import '../../service/dbstructures.dart';
import '../../service/query_service.dart';

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

  ListArticleComponent(this.queryService, this.router);

  void onStarChange() {
    queryService.changeStar(!entry.starred, entry: entry).catchError((e) {
      entry.starred = !entry.starred;
      print(e);
    });
  }
  
  void readPost(postId) {
    
    this.router.gotoUrl("/post/$postId");
  }
}
