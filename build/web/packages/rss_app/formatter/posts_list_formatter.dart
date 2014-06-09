library rssapp.formatter.postslistformatter;

import 'dart:math';

import 'package:angular/angular.dart';
import '../service/dbstructures.dart';

@Formatter(name: 'postlist')
class PostsListFormatter {
  List call(List<FeedEntry> posts, int feedId, [int max=20]){
    if(posts == null) return null;
    int length = min(posts.length, max);
    
    var feedEntries = [];
    for(int i=0, len = posts.length; i<len; i++){
      if(posts[i].feedid == feedId){
        feedEntries.add(posts[i]);
        if(feedEntries.length >= length){
          break;
        }
      }
    }
    
    return feedEntries;
  }
  
}