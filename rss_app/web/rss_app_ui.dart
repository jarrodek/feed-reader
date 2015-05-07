library rssapp_polymer.ui;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';

import 'rss_model.dart';
import 'lib/rss_database/dbstructures.dart';
import 'lib/rss_add_feed/rss_add_feed.dart';
import 'lib/rss-settings/rss-settings.dart';


@CustomTag('rss-app-ui')
class RssApplicationUI extends PolymerElement {
  Router router = new Router();
  RssApplicationUI.created() : super.created();
  /// True if add feed dialog is displayed. For UI purpose. 
  @observable bool addDialogOpened = false;
  /// True if current layout is narrow.
  @observable bool narrow = false;
  /// Currently selected feed.
  @published String currentfeedid;
  /// Currently selected post.
  @published String currentpostid;
  /// Current page to show.
  @published String page;
  /// Tag to be displayed.
  @published String tag;
  
  @observable int selectedPage = 0;
  /// Selected by the user feed.
  @observable Feed selectedFeed;
  /// Selected by the user entry
  @observable FeedEntry selectedEntry;
  /// True if background page is loading new data.
  @published bool backgroundloading;
  @published String menuItemSelected; 
  
  /// Current page of entries (in pagination)
  @published String entriespage;
  /// True if drawer is currently visible in UI.
  bool drawerVisible = true;
  @observable String pageTitle = 'Feed reader';
  @observable bool hasPrevPost = false;
  @observable bool hasNextPost = false;
  
  @observable bool listView = true;
  @observable bool analyticsEnabled;
  @observable String appVersion;
  
  RssModel _model;
  /// List of RSS feeds added by the user.
  List<Feed> _feeds = toObservable([]);
  @observable List<Feed> get feeds => _feeds;
  void set feeds(List<Feed> feeds){
    _feeds.clear();
    _feeds.addAll(feeds);
  }
  
  /// A list of entries in currently selected feed.
  List<FeedEntry> _entries = toObservable([]);
  @observable List<FeedEntry> get entries => _entries;
  
  void set entries(List<FeedEntry> entries){
    if(entries == null){
      _entries.clear();
    } else {
      if(currentfeedid != 'unread'){
        ///for "unread" it's already sorted in the [RssDatabase].
        entries.sort( (FeedEntry e1, FeedEntry e2) => -e1.createtime.compareTo(e2.createtime) );
      }
      _entries.addAll(entries);
    }
  }  
  
  
  void setModel(RssModel model){
    _model = model;
  }
  
  void _showToast(String message){
    Element toast = (this.$['toast'] as Element);
    toast.setAttribute('opened', "false");
    toast.setAttribute('text', message);
    toast.setAttribute('opened', "true");
  }
  
  void openAddDialog(){
    (this.$['addFeedDialog'] as RssAddFeed).open();
  }
  void openSettingsDialog(){
    analyticsEnabled = _model.isTrackingPermitted;
    appVersion = _model.appVersion;
    (this.$['settingsDialog'] as RssSettings).open();
  }
  void analyticsEnabledChanged(bool from, bool to){
    if(from == null) return; //initial setup.
    
    _model.isTrackingPermitted = to;
  }
  
  void currentfeedidChanged(String oldValue, String newValue){
    if(_model == null) return;
    menuItemSelected = currentfeedid;
    this.async((_){
      _getCurrentEntries();
      _updatePageTitle();
    });
    
  }
  
  void pageChanged(){
    switch(page){
      case 'entry':
        selectedPage = 1;
        listView = false;
        break;
      case 'tag':
        selectedPage = 0;
        listView = true;
        _getCurrentEntries();
        _updatePageTitle();
        break;
      default:
        listView = true;
        selectedPage = 0;
    }
  }
  
  void currentpostidChanged(String oldValue, String newValue){
    if(_model == null) return;
    if(newValue != null && newValue != 'null'){
      _selectCurrentEntry();
    } else {
      selectedEntry = null;
    }
  }
  
  ///A handler for accepting new feed dialog.
  void addFeedHandler(CustomEvent e){
    String url = (e.detail as Map)['url'];
    if(url.startsWith('http')){
      _model.addFeed(url).then((Feed feed){
        _feeds.add(feed);
        _model.updateFeedData();
      }).catchError((e){
        _showToast(e.message);
      });
    } else {
      _showToast('Should be valid URL.');
    }
  }
  
  ///A handler to toggle a drower.
  void openDrawer(){
    drawerVisible = true;
    (this.$['drawerPanel'] as HtmlElement).setAttribute('selected', drawerVisible ? 'drawer' : 'main');
  }
  
  @override
  void attached() {
    super.attached();
    this.$['drawerPanel'].on['core-select'].listen(polymerDrawerSupport);
    this.addEventListener('feed-updated', _externelEventsHandler);
  }
  
  
  _externelEventsHandler(CustomEvent e){
    if(e.type == "feed-updated"){
      int _id = e.detail['feedid'];
      Feed feed = _getFeed(_id);
      if(feed == null){
        print('Feed $_id not found');
        return;
      }
      feed.newItems = true;
      
      _model.getFeed(_id).then((Feed f){
        try{
          Feed existing = _feeds.firstWhere((Feed indexed) => indexed.id == f.id);
          int index = _feeds.indexOf(existing);
          _feeds.replaceRange(index, index+1, [f]);
        } catch(e, trace){
          print("Error: $e, $trace");
        }
      }).catchError((){});
      
      
      if(currentfeedid == 'unread' && entries.isEmpty){
        _getCurrentEntries();
      } else if(currentfeedid == 'unread' || currentfeedid == _id.toString()){
        _showToast("New entries are available for this feed.");
      }
    }
  }
  
  /// It is a handler for core-draver-panel's core-select event. It will reset drawerVisible variable when drawer panel is hidden.
  void polymerDrawerSupport(CustomEvent e){
    String selected = (this.$['drawerPanel'] as HtmlElement).getAttribute('selected');
    if(selected != null && selected.isNotEmpty && drawerVisible && selected == 'main'){
      drawerVisible = false;
    }
  }
  
  /// React on layout change - when the drawer hide it should also display "menu" icon.
  void onLayoutChange(CustomEvent e){
    try{
      Map detail = (e.detail as Map);
      if(detail.containsKey('narrow') && detail['narrow'] is bool){
        narrow = detail['narrow'];
      }
    } catch(ex){}
  }
  
  _selectCurrentEntry(){
    String postId = Uri.decodeComponent(currentpostid);
    selectedEntry = _entries.firstWhere((FeedEntry _test) => _test.entryid == postId, orElse: (){
      selectedEntry = null;
    });
  }
 
  /// Refresh entries for current feed and set selected feed/entry
  void _getCurrentEntries(){
    
    this.selectedEntry = null;
    if(page != 'tag'){
      //select current feed
      this.currentpostid = null;
      if(_isNumeric(currentfeedid)){
        selectedFeed = feeds.firstWhere((Feed _test) => _test.id.toString() == currentfeedid, orElse: (){
          selectedFeed = null;
        });
      }
    }
    this.entries = null;
    //print('Requesting for entries');
    _requestForEntries();
  }
  
  @observable bool requestingEntries = false;
  void _requestForEntries(){
    if(requestingEntries){
      return;
    }
    requestingEntries = true;
    if(entriespage == "0" && !entries.isEmpty){
      entries = null;
    }
    _model.listEntries().then((List<FeedEntry> entries) {
      //print('entries.len: ${entries.length}, page: $page, tag: $tag');
      this.entries = entries;
      requestingEntries = false;
      if(entries.length > 0){
        hasNextPost = true;
      }
    });
  }
  
  ///A handler for app menu item select. 
  void menuAction(CustomEvent e, b, Element target){
    String id = target.getAttribute("item");
    switch(id){
      case 'unread':
      case 'starred':
      case 'all':
        //print('Assigning new location: #/$id');
        this.async((_){
          window.location.assign('#/$id');
        });
      break;
      default:
        if(_isNumeric(id)){
          this.async((_){
            Feed f = _getFeed(int.parse(id));
            if(f != null)
              f.newItems = false;
            //print('Assigning new location: #/feed/$id');
            window.location.assign('#/feed/$id');
          });
        }
    }
  }
  
  ///Get feed by id
  Feed _getFeed(int id){
    try {
      return feeds.firstWhere((Feed f) => f.id == id);
    } catch(e){
      return null;
    }
  }
  
  
  //Updates title according to user place.
  void _updatePageTitle() {
    
    switch(page){
      case 'feed':
        switch(currentfeedid){
          case 'unread':
            pageTitle = 'Unread';
            break;
          case 'starred':
            pageTitle = 'Starred';
            break;
          case 'all':
            pageTitle = 'All';
            break;
          default:
            pageTitle = selectedFeed == null ? '' : selectedFeed.display;
        }
      break;
      case 'entry':
        break;
      case 'tag':
        pageTitle = 'Results for: ${tag}';
        break;
    }
    
    
  }
  
  /// Check if give parameter is numeric.
  bool _isNumeric(s) {
    if(s is num) return true;
    return num.parse(s, (e) => null) != null; 
  }
  
  /// Function called when entry's star state change
  void onEntryStarChange(CustomEvent e, b, Element target){
    FeedEntry entry = e.detail['entry'];
    if(entry == null){
      if(selectedEntry == null){
        window.console.warn("Trying to star an entry but no antry is available.");
        return;
      }
      entry = selectedEntry;
    }
    bool oryg = entry.starred;
    this.fire('ga-event', detail: {'category': 'Feed', 'action': 'Star', 'label': !oryg ? 'starred': 'unstarred'});
    _model.updateEntry(entry).catchError((_) => entry.starred = !oryg );
  }
  
  /// A handler to handle post read action. It will assing history string to the URL.
  void readPostHandler(CustomEvent e, b, Element target){
    FeedEntry entry = e.detail['entry'];
    if(entry != null){
      window.location.assign('#/entry/${Uri.encodeComponent(entry.entryid)}');
    } else {
      print('No entry found');
    }
  }
  /// Open the entry in new tab. @todo: add analytics event.
  void openEntry(CustomEvent e, b, Element target){
    var url = target.attributes['href'];
    if(url == null) return;
    //window.open(url, selectedEntry.title);
    this.fire('open-entry', detail: {'url': url, 'name': selectedEntry.title});
  }
  
  /// Move to the previous post
  void prevPost(Event e){
    var i = entries.indexOf(selectedEntry);
    i--;
    if(i < 0){
      return;
    }
    FeedEntry entry = entries[i];
    window.location.assign('#/entry/${Uri.encodeComponent(entry.entryid)}');
    String trigger = 'pagination';
    if(e.type == 'prev-post'){
      trigger = 'keyboard';
    }
    this.fire('ga-event', detail: {'category': 'Nav', 'action': 'Prev', 'label': trigger});
  }
  /// Move to the next post. 
  void nextPost(Event e){
    var i = entries.indexOf(selectedEntry);
    i++;
    if(i > entries.length-1){
      return;
    }
    FeedEntry entry = entries[i];
    window.location.assign('#/entry/${Uri.encodeComponent(entry.entryid)}');
    String trigger = 'pagination';
    if(e.type == 'next-post'){
      trigger = 'keyboard';
    }
    this.fire('ga-event', detail: {'category': 'Nav', 'action': 'Next', 'label': trigger});
  }
  
  ///Function calles when selectedEntry has changed.
  void selectedEntryChanged(){
    var i = entries.indexOf(selectedEntry);
    hasPrevPost = i > 0;
    hasNextPost = !(i >= entries.length-1);
    HtmlElement el2 = (this.$['contentPanel'] as HtmlElement).shadowRoot.querySelector('#mainContainer');
    el2.scrollTop = 0;
    if(!hasNextPost){
      _requestForEntries();
    }
    if(selectedEntry != null && selectedEntry.unread){
      _model.setRead(selectedEntry, true);
    }
  }
  
  /// A handler called for each main content's scroll event 
  void mainContentScroll(CustomEvent e, Map detail, Element target){
    if(_model == null) return;
    if(selectedEntry != null) return;
    
    HtmlElement scroller = detail['target'] as HtmlElement;
    
    int bottomLine = scroller.scrollTop + scroller.offsetHeight;
    int bottomLimit = scroller.scrollHeight;
    int delta = 100; //delta == 100 px
    if(bottomLine+delta > bottomLimit){ 
      _requestForEntries();
    }
  }
  
  /// Return from displaying post to the feed entries list.
  displayCurrentFeed(){
    this.fire('back-action');
  }
  
  /// A handler to mark post as unread.
  void markPostUnread(){
    _model.setRead(selectedEntry, false);
    this.fire('ga-event', detail: {'category': 'Entry', 'action': 'Unread'});
    displayCurrentFeed();
  }
  
  ///Mark all curently loaded posts read. 
  void markAllRead(){
    List _entries = [];
    entries.forEach((FeedEntry entry) {
      if (!entry.unread) {
        return;
      }
      entry.unread = false;
      _entries.add(entry);
    });
    _model.updateEntries(_entries);
    this.fire('ga-event', detail: {'category': 'Feeds', 'action': 'Mark current read'});
  }
  
  /// Refresh all feeds - force download new entries.
  void refreshFeeds(){
    _model.updateFeedData();
  }
  
  void cancelEvent(Event e){
    e.preventDefault();
    e.stopPropagation();
    e.stopImmediatePropagation();
  }
  
  void toggleFeedStar(Event e, Map details, Element target){
    String id = target.attributes['fid'];
    if(id == null) return;
    if(!_isNumeric(id)) return;
    Feed feed = _getFeed(int.parse(id));
    if(feed == null){
      return;
    }
    feed.starred = !feed.starred;
    this.fire('ga-event', detail: {'category': 'Entry', 'action': 'Star', 'label': feed.starred ? 'starred' : 'unstarred'});
    _model.updateFeed(feed);
  }
  
  void clearFeed(Event e, Map details, Element target){
    String _id = target.attributes['fid'];
    if(_id == null) return;
    int id = int.parse(_id);
    _model.clearEntries(id).then((_){
      _entries.removeWhere((FeedEntry _t) => _t.feedid == id);
      _showToast("Feed has been cleared");
    });
  }
  
  void removeFeed(Event e, Map details, Element target){
    String _id = target.attributes['fid'];
    if(_id == null) return;
    
    if(!_isNumeric(_id)) {
      _showToast("Can't remove the feed. An error occured that can't be fixed.");
      return;
    }
    Feed f = _getFeed(int.parse(_id));
    if(f == null){
      _showToast("Can't remove the feed. An error occured.");
      return;
    } //http://blog.gdgpoland.org/feeds/posts/default
    
    _model.clearEntries(f.id).then((_){
      _entries.removeWhere((FeedEntry _t) => _t.feedid == f.id);
      _model.removeFeed(f).then((_){
        feeds.removeWhere((Feed _t) => _t.id == f.id);
        _showToast("Feed has been removed");
      });
    });
  }
  
  void share(Event e, Map details, Element target){
    String media = target.attributes['media'];
    String shareUrl;
    String encodedUrl = Uri.encodeFull(selectedEntry.url);
    switch(media){
      case 'facebook':
        shareUrl = 'https://www.facebook.com/sharer/sharer.php?u=';
        break;
      case 'google':
        shareUrl = 'https://plus.google.com/share?url=';
        break;
      case 'twitter':
        shareUrl = 'https://twitter.com/intent/tweet?url=';
        break;
      case 'linkedin':
        shareUrl = 'https://www.linkedin.com/shareArticle?mini=true&url=';
        break;
      case 'pinterest':
        shareUrl = 'https://pinterest.com/pin/create/button/?url=';
        break;
      case 'tumblr':
        shareUrl = 'http://www.tumblr.com/share/link?url=';
        break;
    }
    
    shareUrl = "$shareUrl$encodedUrl";
    //window.open(shareUrl, "Share");
    this.fire('ga-social-event', detail: {'network': media, 'action': share, 'target': 'entry'});
    this.fire('open-entry', detail: {'url': shareUrl, 'name': 'Share'});
  }
}
