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
    if (!e.uri.startsWith('/post')) {
      //If the user doeasn't read entries list means that the tist itself will change.
      this.queryService.entries.clear();
      queryService.feedId = null;
      queryService.entryId = null;
    }

    e.completed.then(_checkRoute);
  }

  void _checkRoute(_) {
    _handleRoute(routeProvider.routeName, routeProvider.parameters);
  }

  void _handleRoute(String routeName, Map<String, String> parameters) {
    switch (routeName) {
      case 'unread':
      case 'starred':
      case 'all':
        _getGenericSource(routeName);
        this.queryService.currentEntriesArea = routeName;
        break;
      
      case 'feed':
        this.queryService.currentEntriesArea = null;
        if (this.queryService.entries.length > 0) {
          return;
        }
        String feedId = parameters['feedId'];
        _getFeedSource(feedId);
        break;
      
      default:
        //pass
        break;
    }
  }

  void _getGenericSource(String source) {
    this.queryService.populateEntries(source);
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
        print("No feed in response.");
        return;
      }
      queryService.feedId = feedId;
      queryService.populateEntries(_feedId);
    });

  }
}
