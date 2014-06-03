library rssapp.component.addfeedheader;

import 'dart:html';

import 'package:angular/angular.dart';

import '../../service/query_service.dart';

@Component(
    selector: 'add-feed-header', 
    templateUrl: 'packages/rss_app/component/add_feed_header/add_feed_header.html',
    cssUrl: 'packages/rss_app/component/add_feed_header/add_feed_header.css', 
    publishAs: 'cmp')
class AddFeedHeqaderComponent {
  QueryService queryService;
  bool showAddFeed = false;
  String feedAddUrl = "";

  AddFeedHeqaderComponent(QueryService this.queryService);

  void addFeed() {

    if (!feedAddUrl.startsWith("http")) {
      //TODO: error handling.
      return;
    }

    queryService.addFeed(feedAddUrl).then((_) {
      feedAddUrl = '';
      //TODO: refresh feed.
    }).catchError((error) => window.console.error(error));
  }
}
