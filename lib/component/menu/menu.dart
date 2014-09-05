library rssapp.component.menu;

import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';


@Component(selector: 'app-menu', 
    templateUrl: 'packages/rss_app/component/menu/menu.html', 
    cssUrl: const ['packages/rss_app/component/menu/menu.css'], 
    publishAs: 'Menu')
class MenuComponent extends AttachAware with DetachAware{

  bool showOptions = false;
  StreamSubscription<MouseEvent> subscription;

  void toggleOptions(MouseEvent e) {
    e.preventDefault();
    showOptions = !showOptions;
    print('Toggle');
  }
  
  void attach(){
    subscription = window.onClick.listen(_onClick);
  }
  
  ///Issue: For window ther's always feed-list element as a target. 
  void _onClick(MouseEvent e){
    if((e.target as Element).nodeName.toLowerCase() == 'feed-list'){
      return;
    }
    if(showOptions){
      showOptions = false;
    }
  }
  
  void detach(){
    subscription.cancel();
  }
}
