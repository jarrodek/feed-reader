library rssapp.rssapp_controller;

import 'package:angular/angular.dart';

@Controller(selector: '[rss-app]', publishAs: 'ctrl')
class RssController {
  
}
//http://blog.gdgpoland.org/feeds/posts/default, http://stackoverflow.com/feeds/tag/dart, https://www.blogger.com/feeds/1989580893980143369/posts/default
//http://stackoverflow.com/feeds/tag/google-chrome, http://stackoverflow.com/feeds/tag/html http://stackoverflow.com/feeds/tag/css
//dart2js ./web/rss_app.dart --csp -o ./js/rss_app.dart.js -m