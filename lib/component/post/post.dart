library rssapp.component.post;

import 'dart:html';

import 'package:angular/angular.dart';
import '../../service/dbstructures.dart';
import '../../service/query_service.dart';
import '../../service/image_service.dart';
import '../../service/analytics.dart';

@Component(selector: 'post-item', templateUrl: 'packages/rss_app/component/post/post.html', publishAs: 'Post', cssUrl: const ['packages/rss_app/component/post/post.css'])
class PostComponent {

  FeedEntry entry;
  
  QueryService queryService;
  RouteProvider routeProvider;
  ImageService imageService;
  AnalyticsService analytics;

  String imageUrl;
  bool showOptions = false;

  PostComponent(this.routeProvider, this.queryService, this.imageService, this.analytics) {
    String _entryId = routeProvider.parameters['postId'];
    queryService.entryId = Uri.decodeComponent(_entryId);
    
    queryService.getEntry(queryService.entryId).then(_handleEntry).catchError(_handleEntryError);
    
    analytics.trackPageview('Reading post');
  }
  
  List<String> get categories {
    var res = [];
    entry.categories.forEach((String category) => res.add(Uri.encodeComponent(category)));
    return res;
  }
  
  bool get showRightFrame {
    if(entry.categories.length > 0){
      return true;
    }
    return false;
  }
  
  String getCategoryUrl(category) => '#/tag/${Uri.encodeComponent(category)}';

  void _handleEntry(FeedEntry entry) {
    this.entry = entry;
    if (entry.unread) {
      queryService.setEntryRead(entry, true).then((_) {
        this.entry = entry;
      });
    }
    _handleAuthorImage();
  }

  void _handleEntryError(e) {
    //TODO: error reporting.
    print(e);
  }

  void frameLoad(Event e) {
    IFrameElement webview = (e.target as IFrameElement);
    webview.contentWindow.postMessage({
      "action": "paste",
      "html": entry.content
    }, "*");
  }


  void _handleAuthorImage() {
    if (entry.author == null) return;
    if (entry.author.image == null) return;
    if (entry.author.image.src == null) return;

    imageService.getImage(entry.author.image.src).then((String url) {
      imageUrl = url;
    });
  }

  void onStarChange() {
    queryService.changeStar(!entry.starred, entry: entry).catchError((e) {
      print(e);
    });
    String mark = !entry.starred == true ? 'starred' : 'unstarred';
    analytics.trackEvent('Entry', 'Star', mark);
  }

  void toggleOptions() {
    showOptions = !showOptions;
  }

  void unreadEntry() {
    queryService.setEntryRead(entry, false).then((entry) {
      this.entry = entry;
    });
    analytics.trackEvent('Entry', 'Unread', '1');
  }
  
  ///This will only report to GA number of article opens.
  void reportOpen(String buttonSource){
    analytics.trackEvent('Entry', 'Open', buttonSource);
  }
}
