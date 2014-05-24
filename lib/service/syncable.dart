library rssapp.syncable;

import 'dart:async';

import 'package:chrome/chrome_app.dart' as chrome;

abstract class Syncable {
  
  Future storeChrome(String key, obj){
    //var completer = new Completer();
    
    return chrome.storage.sync.set({key: obj});
    
    //return completer.future;
  }
  
  Future restoreChrome(String key){
    return chrome.storage.sync.get([key]);
  }
  
  Future store();
  Future restore();
}