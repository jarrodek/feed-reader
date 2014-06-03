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
    applyAuthorStyles: true,
    publishAs: 'cmp')
class StarringComponent {
  static const String _STAR_ON_CHAR = "\u2605";
  static const String _STAR_OFF_CHAR = "\u2606";
  static const String _STAR_ON_CLASS = "star-on";
  static const String _STAR_OFF_CLASS = "star-off";

  @NgTwoWay('starred')
  bool starred;

  String starClass() => starred ? _STAR_ON_CLASS : _STAR_OFF_CLASS;
  String starChar() => starred ? _STAR_ON_CHAR : _STAR_OFF_CHAR;

  void handleClick() {
    starred = !starred;
  }
}
