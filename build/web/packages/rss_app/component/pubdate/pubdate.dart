library rssapp.component.pubdate;

import 'package:angular/angular.dart';

@Component(
    selector: '[pubdate]',
    templateUrl: 'packages/rss_app/component/pubdate/pubdate.html',
    cssUrl: 'packages/rss_app/component/pubdate/pubdate.css',
    publishAs: 'Pubdate',
    map: const {
      'datetime': '@datetime'
    })
class PubdateComponent {
  
  String datetime;
  DateTime _formatted;
  
  DateTime get formattedTime {
    if(_formatted != null) return _formatted;
    
    if(datetime == null) return null;
    DateTime dt;
    try{
      dt = DateTime.parse(datetime);
    } catch(e){
      return null;
    }
    _formatted = dt;
    return dt;
  }
}