library rssapp.formatter.textformatter;

import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';

@Formatter(name: 'truncate')
class TruncateFilter {
  String call(String input, [int length=100, bool cleanHTML = false, bool exact=true]){
    if(input == null) return "";
    
    String ellipsis = '...';
    
    if(cleanHTML){
      SanitizeFilter sf = new SanitizeFilter();
      input = sf.call(input);
    }
    
    input = input.trim();
    int strlen = input.length;
    
    if(strlen <= length){
      return input;
    }
    
    String truncate = input.substring(0, length-3);
    if(!exact){
      int lastSpacePos = truncate.lastIndexOf(new RegExp(' '));
      truncate = truncate.substring(0, lastSpacePos);
    }
    truncate = "$truncate$ellipsis";
    return truncate;
  }
  
}
@Formatter(name: 'sanitize')
class SanitizeFilter {
  String call(String input){
    if(input == null) return "";
    DocumentFragment fragment = new DocumentFragment.html(input);
    input = fragment.text.trim();
    fragment = null;
    //HtmlEscape tr = new HtmlEscape(HtmlEscapeMode.ELEMENT);
    //input = tr.convert(input);
    return input;
  }
}