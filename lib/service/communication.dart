library rssapp.service.communication;

import 'dart:js' as js;
import 'dart:html';

import 'query_service.dart';

import 'package:chrome/chrome_app.dart' as chrome;
import 'package:angular/angular.dart';

@Injectable()
class AppComm {
  
  QueryService queryService;
  AppComm(this.queryService){
    js.context['feedUpdated'] = onFeedUpdated;
    js.context['feedLoading'] = onFeedLoading;
  }
  /// A flag set to true when background page is loading RSS data.
  bool updatingFeeds = false;
  
  
  void onFeedUpdated(feedId){
    print('>>> onFeedUpdated: $feedId');
    this.queryService.countUnread(feedId, true);
  }
  
  void onFeedLoading(bool isLoading){
    print('>>> onFeedLoading: $isLoading');
    updatingFeeds = isLoading;
  }
  
  void refreshFeeds(){
    try {
      chrome.runtime.getBackgroundPage().then((eventPage) {
        try{
          eventPage.jsProxy['feed'].callMethod('update', []);
        } catch(e){
          window.console.error(e);
        }
      });
    } catch(e){
      print('Not inside Chrome app env.');
      window.console.error(e);
    }
  }
  
}
