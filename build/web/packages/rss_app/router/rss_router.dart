library rssapp.routing.app_router;

import 'package:angular/angular.dart';

void rssAppRouteInitializer(Router router, RouteViewFactory views) {
  
  views.configure({
    'unread': ngRoute(path: '/unread', defaultRoute: true, view: 'view/unread.html'),
    'starred': ngRoute(path: '/starred', view: 'view/starred.html'),
    'all': ngRoute(path: '/all', view: 'view/all.html'),
    'feed': ngRoute(path: '/feed/:feedId', mount: {
      'view': ngRoute(path: '/view', view: 'view/feed.html'),
      'edit': ngRoute(path: '/edit', view: 'view/feed_settings.html'),
      'feed_default': ngRoute(defaultRoute: true, enter: (RouteEnterEvent e) => router.go('view', {}, startingFrom: router.root.findRoute('feed'), replace: true))
    }),
    'post': ngRoute(path: '/post/:postId',view: 'view/post.html')
  });
}
