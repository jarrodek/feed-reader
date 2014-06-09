library rssapp.service.communication;

import 'dart:js';
import 'dart:html';

import 'package:chrome/chrome_app.dart' as chrome;
import 'package:angular/angular.dart';

@Injectable()
class AppComm {
  
  AppComm(){
    
    context['feedUpdated'] = (feedId) {
       print('NNNNNNEEEWWWWWW FEEEEEEEEDDDDDD DATA. Feed has been updated in the event page. $feedId');
    };
    
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
