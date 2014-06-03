library rssapp.component.pubdate;

import 'package:angular/angular.dart';

@Component(
    selector: '[pubdate]',
    templateUrl: 'packages/rss_app/component/pubdate/pubdate.html',
    publishAs: 'cmp',
    map: const {
      'datetime': '@datetime'
    },
    useShadowDom: false)
class PubdateComponent {
  
  String datetime;
  
}