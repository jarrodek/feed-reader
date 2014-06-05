library rssapp.formatter.postslistformatter;

import 'dart:math';

import 'package:angular/angular.dart';

@Formatter(name: 'postlist')
class PostsListFormatter {
  List call(List posts, [int max=20]){
    if(posts == null) return null;
    int length = min(posts.length, max);
    return posts.sublist(0, length);
  }
  
}