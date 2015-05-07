library chrome.app.image;

import 'dart:async';
import 'dart:html' as dom;

import 'package:polymer/polymer.dart';

/**
 * A class repreenting RSS/Atom list item.
 * Can have two states: unread or read.
 */
@CustomTag('chrome-app-image')
class ChromeAppImage extends PolymerElement {

  @published String src;
  @published String alt;
  @published String width;
  @published String height;
  @observable String chrome_src;
  @observable bool loaded = false;
  @observable bool error = false;
  
  //@observable String get image_height => height == null ? '100%' : height;
  //@observable String get image_width => width == null ? '100%' : width;

  ChromeAppImage.created() : super.created();
  
  void srcChanged(String oldValue, String newValue) {
    loaded = false;
    error = false;
    chrome_src = null;
    
    if (newValue.startsWith('//')) {
      src = 'https:$newValue';
    }
    if (!newValue.startsWith('http')) {
      return;
    }
    
    _getImage(src).then((String url){
      this.fire('load');
      chrome_src = url;
    }).catchError((_){
      chrome_src = null;
      loaded = false;
      error = true;
    });
    
  }


  Future<String> _getImage(url) {
    var completer = new Completer<String>();
    var uri = Uri.parse(url);
    var request = new dom.HttpRequest()
        ..open("GET", uri.toString(), async: true)
        ..responseType = "blob"
        ..onError.listen((e) {
          completer.completeError(e);
        })
        ..onLoad.listen((dom.ProgressEvent e) {
          String url = _processImage((e.target as dom.HttpRequest).response);
          completer.complete(url);
        });
    request.send();
    return completer.future;
  }

  _processImage(dom.Blob blob) {
    return dom.Url.createObjectUrlFromBlob(blob);
  }
  
  ///Some images may be "pixel" images and should not be displayed at all.
  void imageLoad(dom.Event e, b, dom.Element target){
    dom.ImageElement img = (target as dom.ImageElement);
    if(img.width == 1){
      loaded = true;
      dom.Url.revokeObjectUrl(chrome_src);
      chrome_src = null;
    } else {
      loaded = true;
    }
  }
}
