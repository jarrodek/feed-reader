library rssapp.component.unreadcounter;

import 'package:angular/angular.dart';
import '../../service/query_service.dart';

@Component(
    selector: 'unread-counter',
    templateUrl: 'packages/rss_app/component/unread_counter/unread_counter.html',
    publishAs: 'cmp',
    useShadowDom: false,
    map: const{
      'feed': '@feed'
    })
class UnreadCounterComponent {
  
  String feed;
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