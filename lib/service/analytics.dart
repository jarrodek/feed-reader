library rssapp.service.analytics;

import 'dart:js';
import 'dart:async';
import 'package:angular/angular.dart';

@Injectable()
class AnalyticsService {

  JsObject service;
  List<JsObject> trackers = [];

  AnalyticsService() {
    service = context['analytics'].callMethod('getService', ['chrome_rss_app']);
    trackers.add(service.callMethod('getTracker', ['UA-18021184-10']));
  }

  void trackPageview(String view) {
    for (var i = 0,
        len = trackers.length; i < len; i++) {
      trackers[i].callMethod('sendAppView', [view]);
    }
  }

  void trackEvent(String category, String action, String label, [String value = null]) {
    for (var i = 0,
        len = trackers.length; i < len; i++) {
      trackers[i].callMethod('sendEvent', [category, action, label, value]);
    }
  }

  Future setEnabled(bool enabled) {
    var completer = new Completer();

    (service.callMethod('getConfig', []) as JsObject).callMethod('addCallback', [(JsObject config) {
        config.callMethod('setTrackingPermitted', [enabled]);
        completer.complete();
      }]);

    return completer.future;
  }
  
  Future<bool> isEnabled() {
      var completer = new Completer();

      (service.callMethod('getConfig', []) as JsObject).callMethod('addCallback', [(JsObject config) {
          completer.complete(config.callMethod('isTrackingPermitted', []));
        }]);

      return completer.future;
    }
}
