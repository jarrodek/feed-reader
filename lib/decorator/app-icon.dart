library rssapp.decorator.icon;

import 'dart:html' as dom;
import 'dart:svg' as svg;
import 'package:angular/angular.dart';

@Decorator(
  selector: '[icon]')
class AppIcon {
  
  final Map _paths = const {
    'add': 'M19,13h-6v6h-2v-6H5v-2h6V5h2v6h6V13z',
    'refresh': 'M17.6,6.4C16.2,4.9,14.2,4,12,4c-4.4,0-8,3.6-8,8s3.6,8,8,8c3.7,0,6.8-2.6,7.7-6h-2.1c-0.8,2.3-3,4-5.6,4c-3.3,0-6-2.7-6-6s2.7-6,6-6c1.7,0,3.1,0.7,4.2,1.8L13,11h7V4L17.6,6.4z',
    'check-circle-outline': 'M7.9,10.1l-1.4,1.4L11,16L21,6l-1.4-1.4L11,13.2L7.9,10.1z M20,12c0,4.4-3.6,8-8,8s-8-3.6-8-8s3.6-8,8-8c0.8,0,1.5,0.1,2.2,0.3l1.6-1.6C14.6,2.3,13.3,2,12,2C6.5,2,2,6.5,2,12s4.5,10,10,10s10-4.5,10-10H20z',
    'markunread': 'M22,6l2-2l-2-2l-2,2l-2-2l-2,2l-2-2l-2,2l-2-2L8,4L6,2L4,4L2,2L0,4l2,2L0,8l2,2l-2,2l2,2l-2,2l2,2l-2,2l2,2l2-2l2,2l2-2l2,2l2-2l2,2l2-2l2,2l2-2l2,2l2-2l-2-2l2-2l-2-2l2-2l-2-2l2-2L22,6z M20,8l-8,5L4,8V6l8,5l8-5V8z',
    'select-all': 'M3,5h2V3C3.9,3,3,3.9,3,5z M3,13h2v-2H3V13z M7,21h2v-2H7V21z M3,9h2V7H3V9z M13,3h-2v2h2V3z M19,3v2h2C21,3.9,20.1,3,19,3z M5,21v-2H3C3,20.1,3.9,21,5,21z M3,17h2v-2H3V17z M9,3H7v2h2V3z M11,21h2v-2h-2V21z M19,13h2v-2h-2V13z M19,21c1.1,0,2-0.9,2-2h-2V21z M19,9h2V7h-2V9z M19,17h2v-2h-2V17z M15,21h2v-2h-2V21z M15,5h2V3h-2V5z M7,17h10V7H7V17z M9,9h6v6H9V9z',
    'star-outline': 'M22,9.244l-7.191-0.617L12,2L9.191,8.627L2,9.244l5.455,4.727L5.82,21L12,17.272L18.18,21l-1.635-7.029L22,9.244z M12,15.396l-3.763,2.27l0.996-4.281L5.91,10.507l4.38-0.376L12,6.095l1.71,4.036l4.38,0.376l-3.322,2.878l0.996,4.281L12,15.396z',
    'drawer': 'M12,8c1.1,0,2-0.9,2-2s-0.9-2-2-2c-1.1,0-2,0.9-2,2S10.9,8,12,8z M12,10c-1.1,0-2,0.9-2,2s0.9,2,2,2c1.1,0,2-0.9,2-2S13.1,10,12,10z M12,16c-1.1,0-2,0.9-2,2s0.9,2,2,2c1.1,0,2-0.9,2-2S13.1,16,12,16z',
    'delete': 'M6,19c0,1.1,0.9,2,2,2h8c1.1,0,2-0.9,2-2V7H6V19z M19,4h-3.5l-1-1h-5l-1,1H5v2h14V4z',
    'settings': 'M19.4,13c0-0.3,0.1-0.6,0.1-1s0-0.7-0.1-1l2.1-1.7c0.2-0.2,0.2-0.4,0.1-0.6l-2-3.5C19.5,5.1,19.3,5,19,5.1l-2.5,1c-0.5-0.4-1.1-0.7-1.7-1l-0.4-2.6C14.5,2.2,14.2,2,14,2h-4C9.8,2,9.5,2.2,9.5,2.4L9.1,5.1C8.5,5.3,8,5.7,7.4,6.1L5,5.1C4.7,5,4.5,5.1,4.3,5.3l-2,3.5C2.2,8.9,2.3,9.2,2.5,9.4L4.6,11c0,0.3-0.1,0.6-0.1,1s0,0.7,0.1,1l-2.1,1.7c-0.2,0.2-0.2,0.4-0.1,0.6l2,3.5C4.5,18.9,4.7,19,5,18.9l2.5-1c0.5,0.4,1.1,0.7,1.7,1l0.4,2.6c0,0.2,0.2,0.4,0.5,0.4h4c0.2,0,0.5-0.2,0.5-0.4l0.4-2.6c0.6-0.3,1.2-0.6,1.7-1l2.5,1c0.2,0.1,0.5,0,0.6-0.2l2-3.5c0.1-0.2,0.1-0.5-0.1-0.6L19.4,13z M12,15.5c-1.9,0-3.5-1.6-3.5-3.5s1.6-3.5,3.5-3.5s3.5,1.6,3.5,3.5S13.9,15.5,12,15.5z'
  };
  final Map _polygons = const {
    'chevron-left': '15.4,7.4 14,6 8,12 14,18 15.4,16.6 10.8,12',
    'chevron-right': '10,6 8.6,7.4 13.2,12 8.6,16.6 10,18 16,12',
    'star': '12,17.273 18.18,21 16.545,13.971 22,9.244 14.809,8.627 12,2 9.191,8.627 2,9.244 7.455,13.971 5.82,21',
    'check': '9,16.2 4.8,12 3.4,13.4 9,19 21,7 19.6,5.6',
    'clear': '19,6.4 17.6,5 12,10.6 6.4,5 5,6.4 10.6,12 5,17.6 6.4,19 12,13.4 17.6,19 19,17.6 13.4,12'
  };
  
  AppIcon(dom.Element element){
    
    String icon = element.getAttribute('icon');
    if(icon == null){
      return;
    }
    
    dom.Element _image;
    if(_paths.containsKey(icon)){
      _image = new svg.PathElement()..setAttribute('d', _paths[icon]);
    } else if(_polygons.containsKey(icon)){
      _image = new svg.PolygonElement()..setAttribute('points', _polygons[icon]);
    } else {
      return;
    }
    
    String viewBox = element.getAttribute('view-box');
    if(viewBox == null || viewBox.isEmpty){
      viewBox = "0 0 24 24";
    }
    
    svg.GElement _g = new svg.GElement()
      ..id = icon
      ..append(_image);
    svg.SvgSvgElement _svg = new svg.SvgSvgElement()
      ..append(_g)
      ..setAttribute('viewBox', viewBox)
      ..setAttribute('width', '100%')
      ..setAttribute('height', '100%')
      ..setAttribute('class', element.className);
    
    //element.replaceWith(_svg);
    element.append(_svg);
  }
}