library rssapp.decorator.listarticle;

import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';


@Decorator(selector: '[listarticle]', map: const {'data-id': '@id'})
class ListArticleDecorator extends AttachAware with DetachAware {
  Element element;
  String id;
  StreamSubscription<Event> stream;
  
  ListArticleDecorator(this.element);
  
  
  void attach(){
    Element list = document.querySelector('entries-lists');
    if(list == null){
      list = document.querySelector('feed-entries');
    }
    if(list == null){
      return;
    }
    stream = list.onScroll.listen(_parentScroll);
  }
  
  void detach() {
    stream.cancel();
  }
  
  void _parentScroll(Event e){
    var docViewTop = (e.target as HtmlElement).scrollTop;
    var docViewBottom = docViewTop + (e.target as HtmlElement).offsetHeight;
    
    var elemTop = element.offsetTop;
    var elemBottom = elemTop + element.offsetHeight;
    
    var inView = ((elemBottom >= docViewTop) && (elemTop <= docViewBottom) && (elemBottom <= docViewBottom) &&  (elemTop >= docViewTop));
    
    if(inView){
      (element.parentNode as ShadowRoot).host.attributes['inview'] = 'yes';
    } else {
      (element.parentNode as ShadowRoot).host.attributes['inview'] = 'no';
    }
  }
}