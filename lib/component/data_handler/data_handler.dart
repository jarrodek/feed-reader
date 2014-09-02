library rssapp.component.datahandler;

import 'dart:html';

import 'package:angular/angular.dart';
import '../../service/query_service.dart';
import '../../service/dbstructures.dart';

@Component(selector: 'data-handler', template: '<!-- data handler ready -->', publishAs: 'cmp')
class DataHandlerComponent implements AttachAware {

  QueryService queryService;
  RouteProvider routeProvider;
  Router router;

  DataHandlerComponent(RouteProvider this.routeProvider, Router this.router, QueryService this.queryService);

  void attach() {
    _handleInitial();
    router.onRouteStart.listen(_onRouteStart);
  }

  void _handleInitial() {
    String hash = window.location.hash;
    if (hash != null && !hash.isEmpty) {
      if (hash.substring(1).indexOf('/feed') != -1) {
        try {
          _handleRoute('feed', {
            'feedId': hash.substring(7)
          });
        } catch (e) {
          _getGenericSource('unread');
        }
      }
    } else {
      _getGenericSource('unread');
    }
  }



  void _onRouteStart(RouteStartEvent e) {
    
    var uri = e.uri;
    
    print('DataHandler::_onRouteStart to uri: $uri');
    
    if (!e.uri.startsWith('/post')) {
      //in any other case it means change in posts lists.
      this.queryService.currentPosts.clear();
      queryService.currentFeedId = null;
      queryService.currentPostId = null;
    } else {
      queryService.currentPostId = Uri.decodeComponent(uri.substring(6));
      print('Post id: ${queryService.currentPostId}');
    }

    e.completed.then(_checkRoute);
  }

  void _checkRoute(_) {
    print('DataHandler::_checkRoute');
    _handleRoute(routeProvider.routeName, routeProvider.parameters);
  }

  void _handleRoute(String routeName, Map<String, String> parameters) {
    
    print('DataHandler::_handleRoute - Handling $routeName area.');
    
    switch (routeName) {
      case 'unread':
      case 'starred':
      case 'all':
        _getGenericSource(routeName);
        this.queryService.currentPostsArea = routeName;
        break;
      
      case 'feed':
        this.queryService.currentPostsArea = null;
        if (this.queryService.currentPosts.length > 0) {
          return;
        }
        String feedId = parameters['feedId'];
        print('DataHandler::_handleRoute - Handling route for feed ID $feedId.');
        _getFeedSource(feedId);
        break;
      
      case 'post':

        break;
      default:
        //pass
        break;
    }
  }

  void _getGenericSource(String source) {
    this.queryService.populatePosts(source);
  }

  void _getFeedSource(String _feedId) {
    int feedId;
    try {
      feedId = int.parse(_feedId);
    } catch (e) {
      //TODO: report an error.
      window.console.error(e);
      return;
    }
    queryService.getFeedById(feedId).then((Feed feed) {
      if (feed == null) {
        // TODO: report an error.
        window.console.error("No feed in response.");
        return;
      }
      queryService.currentFeedId = feedId;
      queryService.populatePosts(feedId.toString());
    });

  }
}
