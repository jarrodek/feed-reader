library rssapp.routing.app_router;

import 'package:angular/angular.dart';

void rssAppRouteInitializer(Router router, RouteViewFactory views) {

  views.configure({
    'unread':   ngRoute(path: '/unread', defaultRoute: true, view: 'view/unread.html'),
    'starred':  ngRoute(path: '/starred', view: 'view/starred.html'),
    'all':      ngRoute(path: '/all', view: 'view/all.html'),
    'feed':     ngRoute(path: '/feed/:feedId', view: 'view/feed.html'),
    'tag':      ngRoute(path: '/tag/:tag', view: 'view/tag.html'),
    'settings': ngRoute(path: '/settings', view: 'view/settings.html'),
    'post':     ngRoute(path: '/post/:postId', view: 'view/post.html', dontLeaveOnParamChanges: false)
  });
}
