library rssapp.component.datahandler;

import 'dart:html';

import 'package:angular/angular.dart';
import '../../service/query_service.dart';
import '../../service/dbstructures.dart';

@Component(
    selector: 'data-handler', 
    template: '<!-- data handler ready -->',
    useShadowDom: false,
    publishAs: 'cmp')
class DataHandlerComponent implements AttachAware {
  
  QueryService queryService;
  RouteProvider routeProvider;
  Router router;
  
  DataHandlerComponent(RouteProvider this.routeProvider, Router this.router, QueryService this.queryService){
    _getGenericSource('unread');
  }
  
  void attach() {
    print('DataHandlerComponent::attach');
    router.onRouteStart.listen((RouteStartEvent e){
      print('router.onRouteStart');
      var uri = e.uri;
      if(!e.uri.startsWith('/post')){
        //in any other case it means change in posts lists.
        this.queryService.currentPosts.clear();
        queryService.currentFeedId = null;
        queryService.currentPostId = 0;
      } else {
        try{
          var postId = uri.substring(6);
          queryService.currentPostId = int.parse(uri.substring(6));
        } catch(e){
          queryService.currentPostId = 0;
        }
      }
      print('Entering switch');
      e.completed.then((_){
        switch(this.routeProvider.routeName){
          case 'unread':
          case 'starred':
          case 'all':
            _getGenericSource(this.routeProvider.routeName);
            this.queryService.currentPostsArea = this.routeProvider.routeName; 
            break;
          case 'feed':
            this.queryService.currentPostsArea = null;
            if(this.queryService.currentPosts.length > 0){
              return;
            }
            String feedId = routeProvider.parameters['feedId'];
            _getFeedSource(feedId);
            break;
          case 'post':
            
            break;
          default:
            //pass
            break;
        }
        
      });
    });
  }
  
  void _getGenericSource(String source){
    this.queryService.getPosts(source).then((_) {
      print('[DataHandlerComponent] Posts loaded.');
    });
  }
  
  void _getFeedSource(String _feedId){
     int feedId;
     try{
       feedId = int.parse(_feedId);
     } catch(e){
       //TODO: report an error.
       window.console.error(e);
       return;
     }
     Feed feed = queryService.getFeedById(feedId);
     if(feed == null){
       // TODO: report an error.
       window.console.error("No feed in response.");
       return;
     }
     queryService.currentFeedId = feedId; 
     queryService.getPosts(feedId.toString()).then((_) {
       //TODO: finish loading.
     });
   }
}

