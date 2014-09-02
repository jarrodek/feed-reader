library rssapp.component.post;

import 'dart:html';

import 'package:angular/angular.dart';
import '../../service/dbstructures.dart';
import '../../service/query_service.dart';
import '../../service/image_service.dart';

@Component(selector: 'post-item', 
    templateUrl: 'packages/rss_app/component/post/post.html', 
    publishAs: 'Post',
    cssUrl: const [
      'packages/rss_app/component/post/post.css'
    ])
class PostComponent {
  
  FeedEntry entry;
  String elementId = "entry-webview-1";
  
  QueryService queryService;
  RouteProvider routeProvider;
  ImageService imageService;
  
  String imageUrl;
  bool showOptions = false;
  
  PostComponent(RouteProvider this.routeProvider, QueryService this.queryService, ImageService this.imageService){
    
    //String postId = routeProvider.parameters['postId'];
    //print('PostComponent, postId: $postId');
    queryService.getPost(queryService.currentPostId).then(_handleEntry).catchError(_handleEntryError);
  }
  
  void _handleEntry(FeedEntry entry){
    this.entry = entry;
    if(entry.unread){
      queryService.setEntryRead(entry, true).then((_){
        this.entry = entry;
      });
    }
    _handleAuthorImage();
  }
  
  void _handleEntryError(e){
    //TODO: error reporting.
    print(e);
  }
  
  void frameLoad(Event e){
    IFrameElement webview = (e.target as IFrameElement);
    webview.contentWindow.postMessage({"action":"paste","html":entry.content}, "*");
  }
  
  
  void _handleAuthorImage(){
    if(entry.author == null) return;
    if(entry.author.image == null) return;
    if(entry.author.image.src == null) return;
    
    imageService.getImage(entry.author.image.src).then((String url){
      imageUrl = url;
    });
    
  }
  
  void onStarChange(){
    queryService.changeStar(!entry.starred, entry: entry).catchError((e){
      print(e);
    }).then((FeedEntry entry){
      
    });
  }
  
  void toggleOptions(){
    showOptions = !showOptions;
  }
  
  void unreadPost(){
    
    queryService.setEntryRead(entry, false).then((entry){
      this.entry = entry;
    });
  }
}