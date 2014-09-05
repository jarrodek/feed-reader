library rssapp.decorator.image;

import 'dart:html' as dom;
import 'package:angular/angular.dart';

import '../service/image_service.dart';

///It will change image src scheme to fir CSP.
@Decorator(selector: 'img[app-src]', map: const {'app-src': '@src'})
class AppImage {
  dom.Element element;
  ImageService imgService;
  
  AppImage(this.element, this.imgService);
  
  
  void set src(value) {
    if(value == null || value.isEmpty){
      return;
    }
    if(value.startsWith('//')){
      src = 'https:$value';
    }
    if(!value.startsWith('http')){
      return;
    }
    imgService.getImage(value).then((String url){
      (element as dom.ImageElement).src = url;
      _checkPixelImage();
    });
  }
  
  ///Some images may be "pixel" images and should not be displayed at all.
  void _checkPixelImage(){
    (element as dom.ImageElement).onLoad.listen((_){
      if((element as dom.ImageElement).width == 1){
        element.remove();
      }
    });
  }
  
}