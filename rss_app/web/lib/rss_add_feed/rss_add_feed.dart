library rssapp.dialogs.add_feed;

import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('rss-add-feed')
class RssAddFeed extends PolymerElement {
  
  RssAddFeed.created() : super.created();
  
  ///An URL of a feed to be added.
  @observable String url = '';
  @observable bool opened = false;
  
  ///A handler for accepting new feed dialog.
  void addFeedHandler(CustomEvent e){
    this.fire('feed-add', detail: {'url': this.url});
  }
  
  void open(){
    this.opened = true;
  }
  
}