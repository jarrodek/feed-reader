library rssapp.component.settings;

import 'package:angular/angular.dart';
import 'package:chrome/chrome_app.dart' as chrome;
import '../../service/analytics.dart';

@Component(selector: 'app-settings', templateUrl: 'packages/rss_app/component/app_settings/app_settings.html', publishAs: 'Settings', cssUrl: const ['packages/rss_app/component/app_settings/app_settings.css'])
class AppSettingsComponent {
  
  AnalyticsService analytics;
  bool analyticsEnabled = true;
  String appVersion = '[loading...]';
  
  AppSettingsComponent(this.analytics){
    analytics.trackPageview('Settings');
    analytics.isEnabled().then((bool enabled) => this.analyticsEnabled = enabled);
    
    appVersion = chrome.runtime.getManifest()['version'];
  }
  
  String get analyticsLabel => analyticsEnabled ? 'enabled' : 'disabled';
  
  void toggleAnalytics(){
    analytics.setEnabled(analyticsEnabled);
  }
}
