library rssapp.component.listarticle;

import 'dart:html';

import 'package:angular/angular.dart';
import '../../service/dbstructures.dart';
import '../../service/query_service.dart';

@Component(selector: 'list-article', 
    templateUrl: 'packages/rss_app/component/lists/list-article.html', 
    cssUrl: 'packages/rss_app/component/lists/list-article.css',
    map: const {
      'entry': '<=>entry'
    }, 
    publishAs: 'Article')
class ListArticleComponent {

  var entry;
  QueryService queryService;
  Router router;

  ListArticleComponent(this.queryService, this.router);

  void onStarChange(FeedEntry entry) {
    queryService.updateEntry(entry).catchError((e) {
      window.console.error(e);
    });
  }
  
  void readPost(postId) {
    this.router.gotoUrl("/post/$postId");
  }
}
