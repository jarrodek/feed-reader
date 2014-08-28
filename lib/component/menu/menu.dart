library rssapp.component.menu;

import 'dart:html';
import 'package:angular/angular.dart';


@Component(selector: 'app-menu', 
    templateUrl: 'packages/rss_app/component/menu/menu.html', 
    cssUrl: const ['packages/rss_app/component/menu/menu.css'], 
    publishAs: 'Menu')
class MenuComponent {

  bool showOptions = false;

  void toggleOptions(MouseEvent e) {
    e.preventDefault();
    showOptions = !showOptions;
  }
}
