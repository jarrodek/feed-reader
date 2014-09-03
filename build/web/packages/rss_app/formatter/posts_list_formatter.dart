library rssapp.formatter.postslistformatter;

import 'dart:math';

import 'package:angular/angular.dart';
import '../service/dbstructures.dart';

@Formatter(name: 'postlist')
class EntriesListFormatter {
  List call(List<FeedEntry> entries, int feedId, [int max=20]){
    if(entries == null) return null;
    int length = min(entries.length, max);
    
    var feedEntries = [];
    for(int i=0, len = entries.length; i<len; i++){
      if(entries[i].feedid == feedId){
        feedEntries.add(entries[i]);
        if(feedEntries.length >= length){
          break;
        }
      }
    }
    
    return feedEntries;
  }
  
}