library rssapp.service.eventsobserver;

import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';

@Injectable()
class AppEvents {

  StreamController<Map> _streamController;
  Stream<Map> _broadcastStream;

  AppEvents() {
    _streamController = new StreamController<Map>();
    _broadcastStream = _streamController.stream.asBroadcastStream();
    _registerKeyEvents();
  }

  Stream<Map> get broadcastStream => _broadcastStream;

  void _registerKeyEvents() {
    document.onKeyDown.listen((KeyboardEvent e) {
      Map obj;
      
      switch (e.keyCode) {
        case 37: //left arrow
          obj = {
            'dir': 'prev'
          };
        break;
        case 39: //right arrow
          obj = {
            'dir': 'next'
          };
        break;
      }
      
      if(obj == null) return;      
      _streamController.add(obj);
    });
  }

}
