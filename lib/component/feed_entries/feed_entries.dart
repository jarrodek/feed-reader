library rssapp.component.postlist;

import 'dart:html';

import 'package:angular/angular.dart';
import '../../service/dbstructures.dart';
import '../../service/query_service.dart';
import '../../service/analytics.dart';

@Component(selector: 'feed-entries', templateUrl: 'packages/rss_app/component/feed_entries/feed_entries.html', cssUrl: const ['packages/rss_app/component/feed_entries/feed_entries.css'], publishAs: 'Feed')
class FeedEntriesComponent {

  QueryService queryService;
  RouteProvider routeProvider;
  AnalyticsService analytics;

  int get feedId => queryService.feedId;
  List<FeedEntry> get entries => queryService.entries;
  ///Current page for pagination.
  int _page = 0;
  ///The number of entries per page.
  int _countPerPage = 100;
  ///True if there are possibly more entries in the datastore (previous query resulted with [_countPerPage] entries list count)  
  bool hasMore = true;
  ///True if entires list is not scrolled down.
  bool listTopScroll = true;

  FeedEntriesComponent(this.routeProvider, this.queryService, this.analytics) {
    String _feedId = routeProvider.parameters['feedId'];
    int feedId;
    try {
      feedId = int.parse(_feedId);
    } catch (e) {
      //TODO: report an error.
      print(e);
      return;
    }
    
    if(queryService.feedId != feedId){
      queryService.clearState();
      queryService.loadFeeds();
      queryService.feedId = feedId;
      _getNextPage();
    }
    analytics.trackPageview('Reading user\'s feed');
  }
  
  bool loadingPage = false;
  void _getNextPage() {
    if(loadingPage || !hasMore) return;
    loadingPage = true;
    _page++;
    
    if(_page > 1){
      analytics.trackEvent('Feed', 'Load page $_page', 'Pagination');
    }
    
    queryService.feedEntries(feedId, count: _countPerPage, page: _page).then((int count) {
      loadingPage = false;
      if (count < _countPerPage) {
        hasMore = false;
      }
    });
  }


  Feed get feed {
    if (feedId == null) return null;
    for (var i = 0,
        len = queryService.feeds.length; i < len; i++) {
      if (queryService.feeds[i].id == feedId) {
        return queryService.feeds[i];
      }
    }
    return null;
  }
  
  
  final int SCROLL_PADDING = 400;
  void onScroll(Event e){
    Element el = (e.target as Element);
    int st = el.scrollTop;
    int height = el.offsetHeight;
    int sheight = el.scrollHeight;
    
    int bottomPoint = st + height + SCROLL_PADDING;
    
    //print('ScrollTop: $st, offsetHeight: $height, scrollHeight: $sheight, bottomPoint: $bottomPoint');
    
    if(st == 0){
      listTopScroll = true;
    } else {
      if(listTopScroll)
        listTopScroll = false;
    }
    
    if(bottomPoint >= sheight){
      _getNextPage();
    }
  }
}
