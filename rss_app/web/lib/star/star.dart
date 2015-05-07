library rssapp.star;

import 'package:polymer/polymer.dart';

/**
 * This component is responsible for inficating if element is marked as starred.
 * 
 * Example:
 * <star starred="false"></star>
 */
@CustomTag('app-star')
class AppStar extends PolymerElement {
  
  AppStar.created() : super.created();
  
  @published bool starred;
  
  void handleClick() {
    starred = !starred;
    this.fire('star-change', detail: {'starred': starred });
  }
}
