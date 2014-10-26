library rssapp.component.menuitem;

import 'package:angular/angular.dart';

@Component(selector: 'menu-item', 
    templateUrl: 'packages/rss_app/component/menu/menu_item.html', 
    cssUrl: const ['packages/rss_app/component/menu/menu_item.css'],
    publishAs: 'MenuItem',
    map: const {
      'icon': '@icon',
      'label': '@label'
    })
class MenuItemComponent {
  String icon;
  String label;
}