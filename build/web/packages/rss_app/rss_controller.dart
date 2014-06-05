library rssapp.rssapp_controller;

import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';

import 'service/query_service.dart';
import 'service/dbstructures.dart';

@Controller(selector: '[rss-app]', publishAs: 'ctrl')
class RssController {


  QueryService queryService;
  
  
  RssController(QueryService this.queryService);
  
}
