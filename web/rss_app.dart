
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';

import 'package:rss_app/rss_controller.dart';
import 'package:rss_app/service/query_service.dart';
import 'package:rss_app/service/database.dart';
import 'package:rss_app/component/feed_list.dart';
import 'package:rss_app/component/posts_list.dart';
import 'package:rss_app/component/add_feed_header.dart';
import 'package:rss_app/router/rss_router.dart';
import 'package:rss_app/formatter/text_formatter.dart';

class RssAppModule extends Module {
  RssAppModule() {
    type(RssController);
    type(QueryService);
    type(RssDatabase);
    type(FeedListComponent);
    type(PostsListComponent);
    value(RouteInitializerFn, rssAppRouteInitializer);
    factory(NgRoutingUsePushState, (_) => new NgRoutingUsePushState.value(false));
    //bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
    bind(TruncateFilter);
    bind(SanitizeFilter);
    bind(AddFeedHeqaderComponent);
    
    var myValidator = new NodeValidatorBuilder() //.common()
      ..allowHtml5()
      ..allowNavigation()
      ..allowTextElements();
      //..allowCustomElement('test-component', attributes: ['product-id']);
    value(NodeValidator, myValidator);
    
  }
}


void main() {
  Logger.root
      ..level = Level.FINEST
      ..onRecord.listen((LogRecord r) {
        print(r.message);
      });
  RssAppModule module = new RssAppModule();
  applicationFactory().addModule(module).run();
}
