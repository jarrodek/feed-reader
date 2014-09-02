library rssapp.formatter.textformatter;

import 'package:angular/angular.dart';

@Formatter(name: 'truncate')
class TruncateFilter {
  String call(String input, [int length=100, bool exact=true]){
    if(input == null) return "";
    
    String ellipsis = '...';
    
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
