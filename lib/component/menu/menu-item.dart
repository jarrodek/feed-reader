library rssapp.component.menuitem;

import 'dart:html' as dom;
import 'package:angular/angular.dart';

@Decorator(
  selector: 'menu-item')
class MenuItemDecorator {
  
  MenuItemDecorator(dom.Element element){
    element.classes.add("menu-item");
  }
}