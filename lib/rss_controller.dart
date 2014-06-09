library rssapp.rssapp_controller;

import 'package:angular/angular.dart';

import 'service/query_service.dart';
import 'service/communication.dart';

@Controller(selector: '[rss-app]', publishAs: 'ctrl')
class RssController {


  QueryService queryService;
  AppComm communication;
  
  RssController(QueryService this.queryService, AppComm this.communication);
  
  void refreshFeeds(){
    communication.refreshFeeds();
  }
  
}
//http://blog.gdgpoland.org/feeds/posts/default, http://stackoverflow.com/feeds/tag/dart, https://www.blogger.com/feeds/1989580893980143369/posts/default