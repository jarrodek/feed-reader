library rssapp.component.unreadcounter;

import 'package:angular/angular.dart';
import '../../service/query_service.dart';

@Component(
    selector: 'unread-counter',
    templateUrl: 'packages/rss_app/component/unread_counter/unread_counter.html',
    publishAs: 'cmp',
    useShadowDom: false,
    map: const{
      'feed': '@feed',
      'data-class': '@cssClass',
      'data-hide-empty': '@hideEmpty'
    })
class UnreadCounterComponent {
  
  String feed;
  String _cssClass;
  String _hideEmpty;
  
  String get cssClass => _cssClass == null ? "unread-counter" : _cssClass;
  set cssClass(String css) => _cssClass = css;
  
  set hideEmpty(String value) => _hideEmpty = value;
  bool get isHideEmpty => _hideEmpty == null ? false : (_hideEmpty == "true" ? true : false); 
  
  int get unreadCount {
    if(feed == null){
      return queryService.unreadCount;
    }
    int id;
    try{
      id = int.parse(feed);
    } catch(e){
      return 0;
    }
    return queryService.countUnread(id);
  }
  
  QueryService queryService;
  
  UnreadCounterComponent(QueryService this.queryService);
  
}