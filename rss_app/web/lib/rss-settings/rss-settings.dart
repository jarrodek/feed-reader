library rssapp.dialogs.settings;

import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('rss-settings')
class RssSettings extends PolymerElement {
  
  RssSettings.created() : super.created();
  
  @observable bool opened = false;
  @published bool gaenabled;
  
  @published bool gaCheckboxEnabled;
  @published String appversion;
  
  ///A handler for accepting new feed dialog.
  void gaChange(CustomEvent e){
    gaenabled = gaCheckboxEnabled;
  }
  
  void gaenabledChanged(){
    gaCheckboxEnabled = gaenabled;
  }
  
  void open(){
    this.opened = true;
  }
  
}