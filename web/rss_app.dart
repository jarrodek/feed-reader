import 'dart:html';


import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:angular/animate/module.dart';
import 'package:logging/logging.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:rss_app/rss_controller.dart';
import 'package:rss_app/service/query_service.dart';
import 'package:rss_app/service/database.dart';
import 'package:rss_app/service/image_service.dart';
import 'package:rss_app/service/communication.dart';
import 'package:rss_app/service/events_observer.dart';
import 'package:rss_app/component/lists/entries_lists.dart';
import 'package:rss_app/component/lists/list_article.dart';
import 'package:rss_app/component/feed_list/feed_list.dart';
import 'package:rss_app/component/feed_entries/feed_entries.dart';
import 'package:rss_app/component/app-header/app-header.dart';
import 'package:rss_app/component/post/post.dart';
import 'package:rss_app/component/pubdate/pubdate.dart';
import 'package:rss_app/component/unread_counter/unread_counter.dart';
import 'package:rss_app/component/data_handler/data_handler.dart';
import 'package:rss_app/component/star/star.dart';
import 'package:rss_app/component/menu/menu.dart';
import 'package:rss_app/component/menu/menu-item.dart';
import 'package:rss_app/decorator/app-icon.dart';
import 'package:rss_app/router/rss_router.dart';
import 'package:rss_app/formatter/text_formatter.dart';
import 'package:rss_app/formatter/date_formatter.dart';
import 'package:rss_app/formatter/posts_list_formatter.dart';



void main() {
  Logger.root
      ..level = Level.FINEST
      ..onRecord.listen((LogRecord r) {
        print(r.message);
      });
  
  initializeDateFormatting("en", null).then((_) => runApp());
}

void runApp() {
  /*var myValidator = new NodeValidatorBuilder() //.common()
      //..allowHtml5()
      //..allowNavigation()
      ..allowTextElements();
  */
  var rssModule = new Module()
      ..bind(RouteInitializerFn, toValue: rssAppRouteInitializer)
      ..bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false))

      ..install(new AnimationModule())

      ..bind(TruncateFilter)
      ..bind(RelativeDateFilter)
      ..bind(RelativeDayFilter)
      ..bind(EntriesListFormatter)

      //Components
      ..bind(AppHeaderComponent)
      ..bind(StarringComponent)
      ..bind(FeedListComponent)
      ..bind(FeedEntriesComponent)
      ..bind(PostComponent)
      ..bind(PubdateComponent)
      ..bind(UnreadCounterComponent)
      ..bind(EntriesListComponent)
      ..bind(DataHandlerComponent)
      ..bind(MenuComponent)
      ..bind(ListArticleComponent)

      //Decorators
      ..bind(AppIcon)
      ..bind(MenuItemDecorator)

      //Controlers
      ..bind(RssController)

      //Services
      ..bind(QueryService)
      ..bind(ImageService)
      ..bind(RssDatabase)
      ..bind(AppComm)
      ..bind(AppEvents);

      //..bind(NodeValidator, toValue: myValidator);

  applicationFactory().addModule(rssModule).run();
}
