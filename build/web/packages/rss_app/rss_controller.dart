library rssapp.rssapp_controller;

import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';

import 'service/query_service.dart';
import 'service/dbstructures.dart';

@Controller(
    selector: '[rss-app]',
    publishAs: 'ctrl')
class RssController {
  
  
  QueryService queryService;
  List<Feed> get feeds => queryService.feeds;
  int get unreadCount => queryService.unread.length;
  String currentFeed = "unread";
  bool showAddFeed = false;
  String aaa = "aaa";
  
  RssController(QueryService this.queryService){
    print('RssController');
  }
  
}

//http://blog.gdgpoland.org/feeds/posts/default, http://stackoverflow.com/feeds/tag/dart, https://www.blogger.com/feeds/1989580893980143369/posts/default