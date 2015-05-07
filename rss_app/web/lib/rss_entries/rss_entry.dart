library rssapp.lists.feeditem;

import 'dart:html';
import 'dart:async';

import 'package:polymer/polymer.dart';

import '../rss_database/dbstructures.dart';
/**
 * A class repreenting RSS/Atom list item.
 * Can have two states: unread or read.
 */
@CustomTag('rss-entry')
class RssEntry extends PolymerElement {
  
  @published FeedEntry entry;
  @published bool showtitle;
  StreamSubscription<MessageEvent> _iframeMessages;
  StreamSubscription<KeyboardEvent> _keyboardEvents;
  bool _frameLoaded = false;
  @observable bool smallerFont;
  
  
  RssEntry.created() : super.created(){
    _iframeMessages = window.onMessage.listen(_onFrameMessage);
    _keyboardEvents = window.onKeyDown.listen(_onKeyboard);
  }
  
  void _onFrameMessage(MessageEvent e){
    Map data = e.data as Map;
    if(data == null) return;
    
    Window w = e.target as Window;
    String cmd = data['message'];
    switch(cmd){
      case 'ready':
      case 'height-change':
        int height = data['height'];
        (this.$['iframe'] as IFrameElement).attributes['height'] = "$height";
        (this.$['openUrlFab'] as HtmlElement).style.bottom = '17px';
        break;
      case 'navigate':
        String dir = data['dir'];
        if(dir == 'next')
          this.fire('next-post');
        else 
          this.fire('prev-post');
        break;
    }
  }
  
  void _onKeyboard(KeyboardEvent e){
    switch(e.keyCode){
      case 37:
        this.fire('prev-post', detail: {'trigger': 'keyboard'});
      break;
      case 39:
        this.fire('next-post', detail: {'trigger': 'keyboard'});
      break;
    }
  }
  
  void entryChanged(o,n) => _pasteIntoFrame();
  
  void detached() {
    super.detached();
    _iframeMessages.cancel();
    _keyboardEvents.cancel();
  }
  
  
  void frameLoad(Event e, b, Element target){
    _frameLoaded = true;
    _pasteIntoFrame();
  }
  
  _pasteIntoFrame(){
    if(!_frameLoaded || entry == null){
      return;
    }
    IFrameElement webview = (this.$['iframe'] as IFrameElement);
    webview.contentWindow.postMessage({
      "action": "paste",
      "html": entry.content
    }, "*");
  }
  
  List<String> get categories {
    var res = [];
    if(entry == null) return res;
    
    entry.categories.forEach((String category) => res.add(Uri.encodeComponent(category)));
    return res;
  }
  
  String getCategoryUrl(category) => '#/tag/${Uri.encodeComponent(category)}';
  
  void openEntry(Event e, b, Element target) {
    window.open(entry.url, entry.title);
  }
  
  void onEntryStarChange(CustomEvent e, b, Element target){
    e.preventDefault();
    e.stopImmediatePropagation();
    entry.starred = e.detail['starred']; 
    this.fire('star-change', detail: {'entry': entry});
  }
}