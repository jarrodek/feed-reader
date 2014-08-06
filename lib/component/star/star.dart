library rssapp.component.star;

import 'package:angular/angular.dart';
/**
 * This component is responsible for inficating if element is marked as starred.
 * 
 * Example:
 * <star starred="false"></star>
 */
@Component(
    selector: 'star',
    templateUrl: 'packages/rss_app/component/star/star.html',
    cssUrl: 'packages/rss_app/component/star/star.css',
    publishAs: 'cmp',
    map: const {
      'starred': '=>starred'
    })
class StarringComponent {
  
  bool starred;
  
  void handleClick() {
    starred = !starred;
  }
}
