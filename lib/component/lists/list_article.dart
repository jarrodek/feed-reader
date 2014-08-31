library rssapp.component.listarticle;

import 'dart:html';

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
    entry.starred = !entry.starred;
    queryService.updateEntry(entry).catchError((e) {
      //TODO: Inform the user.
      entry.starred = !entry.starred;
      window.console.error(e);
    });
  }
  
  void readPost(postId) {
    this.router.gotoUrl("/post/$postId");
  }
}
