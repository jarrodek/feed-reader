library rssapp.service.imageservice;

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

@Injectable()
class ImageService {
  
  Http _http;
  ImageService(Http this._http);
  
  
  Future<String> getImage(url){
    var completer = new Completer<String>();
    var uri = Uri.parse(url);
    var request = new HttpRequest()
      ..open("GET", uri.toString(), async: true)
      ..responseType = "blob"
      ..onError.listen((e) {
        completer.completeError(e);
      })
      ..onLoad.listen((ProgressEvent e) {
        String url = _processImage((e.target as HttpRequest).response);
        completer.complete(url);
      });
    request.send();
    return completer.future;
  }
  
  _processImage(Blob blob){
    return Url.createObjectUrlFromBlob(blob);
  }
  
}