library rssapp.service.eventsobserver;

import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';

@Injectable()
class AppEvents {
  
  AppEvents(){
    
    window.onKeyDown.listen((KeyboardEvent e){
      switch(e.keyCode){
        case 37: //left arrow
          
          break;
        case 39: //right arrow
          
          break;
      }
    });
    
  }
  
}