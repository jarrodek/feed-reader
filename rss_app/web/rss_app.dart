library rssapp_polymer;

import 'dart:html';
import 'dart:async';
import 'dart:js' as js;

import 'package:polymer/polymer.dart' as polymer;
import 'package:chrome/chrome_app.dart' as chrome;
import 'package:route_hierarchical/client.dart';

import 'lib/analytics.dart' as analytics;
import 'lib/rss_database/rss_database.dart';
import 'lib/rss_database/dbstructures.dart';

import 'rss_app_ui.dart';
import 'rss_model.dart';


analytics.Tracker _analyticsTracker = new analytics.NullTracker();

void main() {
  /*String h = window.location.hash;
  if(h != null && h.isNotEmpty){
    h = h.substring(1);
    querySelector('rss-app-ui').setAttribute('feed', h);
  }*/
  new RssApp();
}

class RssApp extends RssModel {
  static final _ANALYTICS_ID = 'UA-18021184-10';
  
  RssApplicationUI _ui;
  RssDatabase _db;
  Router _router = new Router(useFragment: true);
  
  /// Currently selected feed.
  String _currentFeedId;
  /// Currently selected post.
  String _currentPostId;
  String _currentPage;
  /// For pagination. # of pages loaded from storage
  int _entriesPage = 0;
  int get entriesPage => _entriesPage;
  set entriesPage(int no){
    _entriesPage = no;
    _ui.attributes['entriespage'] = _entriesPage.toString();
  } 
  /// A flag determining if there are more entries for selected feed.
  bool hasMoreEntries = true;
  static const int ENTRIES_PER_PAGE = 30;
  
  RssApp(){
    polymer.initPolymer().run(() {
      polymer.Polymer.onReady.then((_){
        _initAnalytics();
        
        _ui = document.querySelector('rss-app-ui');
        _ui.setModel(this);
        
        _route();
        _initialize();
      });
    });
  }
  
  
  
  /// This app's version from the manifest.
  String get appVersion => chrome.runtime.getManifest()['version'];
  
  /// A handler to the database
  RssDatabase get database {
    if(_db == null){
      _db = document.querySelector('#db') as RssDatabase;
    }
    return _db;
  }
  
  void _initialize(){
    listFeeds().then((List<Feed> feeds) {
      _ui.feeds = feeds;
    });
    
    _ui.addEventListener('back-action', (_) => _router.gotoUrl('/feed/$_currentFeedId'));
    _ui.addEventListener('open-entry', _onEntryOpen);
    _ui.addEventListener('ga-event', _onGeEvent);
    _ui.addEventListener('ga-social-event', _onGaSocialEvent);
    
    _listenBackground();
  }
  
  /// A function to handle adding new feed to the database
  Future<Feed> addFeed(String url) {
    _analyticsTracker.sendEvent('Feed', 'Add');
    return database.addFeed(url);
  }
  
  /// Load feeds list from the database
  Future<List<Feed>> listFeeds() => database.getFeeds();
  
  Future<Feed> getFeed(int id) => database.getFeed(id);
  
  /**
   * Load [FeedEntry] from current feed. 
   * This function is handling pagination - calling it again will result with next page results.
   * [feedId] should be given if current Feed ID is 'post' (reading posts)
   */
  Future<List<FeedEntry>> listEntries([int feedId = null]) {
    if(!hasMoreEntries){
      return new Future.value([]);
    }
    
    int from = entriesPage * ENTRIES_PER_PAGE;
    entriesPage++;
    int to = entriesPage * ENTRIES_PER_PAGE;
    
    _analyticsTracker.sendEvent('Feed', 'Load page $entriesPage', 'Pagination');
    //print('Getting entries for page: $_currentPage, feed: $_currentFeedId, from: $from, to: $to and for tag: ${_ui.attributes['tag']}');
    switch(_currentPage){
      case 'feed':
        switch(_currentFeedId){
          case 'unread':
            return database.listUnread(from: from, to: to).then(_checkResults);
          case 'starred':
            return database.listStarred(from: from, to: to).then(_checkResults);
          case 'all':
            return database.listAll(from: from, to: to).then(_checkResults);
          default:
            try{
              int id = int.parse(_currentFeedId);
              return database.listEntries(id, from: from, to: to).then(_checkResults);
            } catch(e){}
        }
        throw new ArgumentError("A source ($_currentFeedId) is invalid.");
      case 'entry':
        if(feedId != null){
          return database.listEntries(feedId, from: from, to: to).then(_checkResults);
        } else {
          return new Future.value([]);
        }
        break;
      case 'tag':
        String tag = Uri.encodeComponent(_ui.attributes['tag']);
        //print('Requesting for tag: $tag. from: $from, to: $to');
        return database.listTags(tag, from: from, to: to).then(_checkResults);
      default:
        throw "$_currentPage is unknown";
    }
  }
  
  List<FeedEntry> _checkResults(List<FeedEntry> results){
    if(results.length < ENTRIES_PER_PAGE){
      hasMoreEntries = false;
    }
    return results;
  }
  
  
  /// Count number of unread [FeedEntry] from selected [source]: 'unread' or feed ID.
  Future<int> countUnread(String source) {
    switch(source){
      case 'unread':
        return database.countUnread();
      default:
        try{
          int id = int.parse(source);
          return database.countUnread(id);
        } catch(e){
          throw new ArgumentError("A source is invalid.");
        }
    }
  }
  
  /// Update a entry.
  Future<FeedEntry> updateEntry(FeedEntry entry) => database.updateEntry(entry);
  
  /// Update a list of entries in one transaction. 
  Future<List<FeedEntry>> updateEntries(List<FeedEntry> entries) => database.updateEntries(entries);
  
  /// Update a [Feed]
  Future<Feed> updateFeed(Feed feed) => database.updateFeed(feed);
  
  /// Remove feed form the database.
  Future removeFeed(Feed feed) {
    _analyticsTracker.sendEvent('Feed', 'clear');
    return database.removeFeed(feed);
  }
  
  /// Clear entries for specified [feedId]. 
  Future clearEntries(int feedId) {
    _analyticsTracker.sendEvent('Feed', 'clear');
    return database.clearEntries(feedId);
  }
  
  /**
   * Sent [entry] read or unread depending on [read] flag.
   * @TODO: add analytics. 
   */
  Future<FeedEntry> setRead(FeedEntry entry, [bool read = true]){
    entry.unread = !read;
    //_analyticsTracker.sendEvent('Entry', 'Unread');
    return this.updateEntry(entry);
  }
  
  //// UI methods.
  
  /// Refresing the feeds entries. It will send a signal to the background page to do the work. 
  void updateFeedData(){
    _analyticsTracker.sendEvent('Feeds', 'Refresh');
    try {
      chrome.runtime.getBackgroundPage().then((eventPage) {
        try{
          eventPage.jsProxy['rss']['app'].callMethod('update', []);
        } catch(e){
          print(e);
        }
      });
    } catch(e){
      print('Not inside Chrome app env.');
    }
  }
  
  /// Refresh the information about the feed represented by [feedId]. 
  void refreshFeed(String feedId){
    throw "Not yet implemented";
  }
  
  /// Setter for current feed ID
  set currentFeedId(String id) {
    _currentFeedId = id;
    entriesPage = 0;
    hasMoreEntries = true;
    _ui.attributes['currentfeedid'] = id;
  }
  /// Setter for current post ID.
  set currentPostId(String id){
    _currentPostId = id;
    _ui.attributes['currentpostid'] = id;
  }
  
  set currentPage(String page){
    if(page == this._currentPage){
      return;
    }
    entriesPage = 0;
    hasMoreEntries = true;
    this._currentPage = page;
    _ui.attributes['page'] = page;
  }
  
  _route(){
    _router.root
      ..addRoute(name: 'unread', path: '/unread', enter: _defaultRoute, defaultRoute: true)
      ..addRoute(name: 'starred', path: '/starred', enter: _defaultRoute)
      ..addRoute(name: 'all', path: '/all', enter: _defaultRoute)
      ..addRoute(name: 'feed', path: '/feed/:feedId', enter: _showFeed)
      ..addRoute(name: 'entry', path: '/entry/:entryId', enter: _showEntry)
      ..addRoute(name: 'tag', path: '/tag/:tag', enter: _showTag);
    _router.listen();
  }
  
  _defaultRoute(RouteEvent e){
    //print('_defaultRoute: ${e.route.name}');
    _applyFeedRoute(e.route.name);
    _analyticsTracker.sendAppView('System feed: ${e.route.name}');
  }
  _showFeed(RouteEvent e){
    //print('_showFeed: ${e.parameters['feedId']}');
    _applyFeedRoute(e.parameters['feedId']);
    _analyticsTracker.sendAppView('User feed');
  }
  _applyFeedRoute(String route){
    //print('_applyFeedRoute: ${route}');
    currentFeedId = route;
    if(_currentPostId != 'null'){
      currentPostId = 'null';
    }
    currentPage = 'feed';
  }
  
  _showEntry(RouteEvent e){
    //print('_showEntry: ${e.parameters['entryId']}');
    currentPostId = e.parameters['entryId'];
    currentPage = 'entry';
    _analyticsTracker.sendAppView('entry');
  }
  _showTag(RouteEvent e){
    String tag = Uri.decodeComponent(e.parameters['tag']);
    entriesPage = 0;
    currentPage = 'tag';
    currentPostId = 'null';
    _ui.attributes['tag'] = tag;
    _analyticsTracker.sendAppView('tag');
  }
  
  /**
   * Listen for functions call from the background page.
   */
  _listenBackground(){
    js.context['feedUpdated'] = _onFeedUpdated;
    js.context['feedLoading'] = _onFeedLoading;
  }
  
  void _onFeedUpdated(feedId){
    
    if(_currentFeedId == 'unread' || _currentFeedId == feedId.toString()){
      hasMoreEntries = true;
      entriesPage = 0;
    }
    
    _ui.fire('feed-updated', onNode: _ui, detail: {'feedid': feedId});
  }
  
  void _onFeedLoading(bool isLoading){
    _ui.attributes['backgroundloading'] = isLoading.toString();
  }
  
  
  void _initAnalytics() {
    // Init the analytics tracker and send a page view for the main page.
    analytics.getService('chrome_rss_app').then((service) {
      _analyticsTracker = service.getTracker(_ANALYTICS_ID);
      _analyticsTracker.sendAppView('main');
    });
  }
  
  void _onEntryOpen(CustomEvent e){
    String url = e.detail['url'];
    String name = e.detail['name'];
    window.open(url, name);
    _analyticsTracker.sendEvent('Entry', 'Open');
  }
  /// Send event to GA that a feed has been starred. feed-starred event
  void _onGeEvent(CustomEvent e){
    var category = e.detail['category'];
    var action = e.detail['action'];
    var label = e.detail['label'];
    _analyticsTracker.sendEvent(category, action, label);
  }
  
  void _onGaSocialEvent(CustomEvent e){
    var network = e.detail['network'];
    var action = e.detail['action'];
    var target = e.detail['target']; //allow only 'entry'
    _analyticsTracker.sendSocial(network, action, target);
    _analyticsTracker.sendEvent('Social', 'Share', network);
  }
  
  bool get isTrackingPermitted => _analyticsTracker.service.getConfig().isTrackingPermitted();

  set isTrackingPermitted(bool value) => _analyticsTracker.service.getConfig().setTrackingPermitted(value);
}





// Analytics code.

void _handleUncaughtException(error, [StackTrace stackTrace]) {
  // We don't log the error object itself because of PII concerns.
  final String errorDesc = error != null ? error.runtimeType.toString() : '';
  final String desc = '${errorDesc}|${stackTrace}'.trim();
  
  _analyticsTracker.sendException(desc);
  
  window.console.error(error);
  if (stackTrace != null) {
   window.console.error(stackTrace.toString());
  }
}

