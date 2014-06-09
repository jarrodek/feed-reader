
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/application_factory_static.dart';
import 'package:angular/animate/module.dart';
import 'package:logging/logging.dart';

import 'package:rss_app/rss_controller.dart';
import 'package:rss_app/service/query_service.dart';
import 'package:rss_app/service/database.dart';
import 'package:rss_app/service/image_service.dart';
import 'package:rss_app/service/communication.dart';
import 'package:rss_app/component/lists/entries_lists.dart';
import 'package:rss_app/component/feed_list/feed_list.dart';
import 'package:rss_app/component/feed_entries/feed_entries.dart';
import 'package:rss_app/component/add_feed_header/add_feed_header.dart';
import 'package:rss_app/component/post/post.dart';
import 'package:rss_app/component/pubdate/pubdate.dart';
import 'package:rss_app/component/unread_counter/unread_counter.dart';
import 'package:rss_app/component/data_handler/data_handler.dart';
import 'package:rss_app/router/rss_router.dart';
import 'package:rss_app/formatter/text_formatter.dart';
import 'package:rss_app/formatter/date_formatter.dart';
import 'package:rss_app/formatter/posts_list_formatter.dart';
import 'package:rss_app/component/star/star.dart';
import 'rss_app_static_expressions.dart' as generated_static_expressions;
import 'rss_app_static_metadata.dart' as generated_static_metadata;
import 'rss_app_static_injector.dart' as generated_static_injector;


void main() {
  Logger.root
      ..level = Level.FINEST
      ..onRecord.listen((LogRecord r) {
        print(r.message);
      });
  
  var myValidator = new NodeValidatorBuilder() //.common()
        //..allowHtml5()
        //..allowNavigation()
        ..allowTextElements();
        //..allowCustomElement('test-component', attributes: ['product-id']);
  
  var rssModule = new Module()
     ..bind(RouteInitializerFn, toValue: rssAppRouteInitializer)
     ..bind(NgRoutingUsePushState, toFactory: (_) => new NgRoutingUsePushState.value(false))
     
     ..install(new AnimationModule())
     
     ..bind(TruncateFilter)
     ..bind(SanitizeFilter)
     ..bind(RelativeDateFilter)
     ..bind(PostsListFormatter)
     
     ..bind(AddFeedHeqaderComponent)
     ..bind(StarringComponent)
     ..bind(FeedListComponent)
     ..bind(FeedEntriesComponent)
     ..bind(PostComponent)
     ..bind(PubdateComponent)
     ..bind(UnreadCounterComponent)
     ..bind(EntriesListComponent)
     ..bind(DataHandlerComponent)
     
     ..bind(RssController)
     
     ..bind(QueryService)
     ..bind(ImageService)
     ..bind(RssDatabase)
     ..bind(AppComm)
     
     ..bind(NodeValidator, toValue: myValidator);
  
  staticApplicationFactory(generated_static_injector.factories, generated_static_metadata.typeAnnotations, generated_static_expressions.getters, generated_static_expressions.setters, generated_static_expressions.symbols).addModule(rssModule).run();
}
