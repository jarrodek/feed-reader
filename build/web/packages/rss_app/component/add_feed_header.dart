library rssapp.component.addfeedheader;

import 'dart:html';

import 'package:angular/angular.dart';

import '../service/query_service.dart';

@Component(selector: 'add-feed-header', templateUrl: 'packages/rss_app/component/add_feed_header.html', publishAs: 'cmp', applyAuthorStyles: true)
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
