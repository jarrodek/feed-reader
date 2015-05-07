library rssapp.model;

import 'dart:async';

import 'lib/rss_database/dbstructures.dart';
import 'lib/rss_database/rss_database.dart';

abstract class RssModel {
  
  /// This app's version from the manifest.
  String get appVersion;
  
  /// A handler to the database
  RssDatabase get database;
  
  /// A function to handle adding new feed to the database
  Future<Feed> addFeed(String url);
  
  /// Load feeds list from the database
  Future<List<Feed>> listFeeds();
  
  /// Get [Feed] by [id]
  Future<Feed> getFeed(int id);
  
  /**
   * Load [FeedEntry] for selected feed.
   * Implementation should handle pagination.
   */
  Future<List<FeedEntry>> listEntries([int feedId = null]);
  
  /// Count number of unread [FeedEntry] from selected [source] e.g. 'unread' or feed ID.
  Future<int> countUnread(String source);
  
  /// Update a entry.
  Future<FeedEntry> updateEntry(FeedEntry entry);
  
  /// Update a list of entries in one transaction. 
  Future<List<FeedEntry>> updateEntries(List<FeedEntry> entries);
  
  /// Update a [Feed]
  Future<Feed> updateFeed(Feed feed);
  
  /// Remove feed form the database.
  Future removeFeed(Feed feed);
  
  /// Clear entries for specified [feedId]. 
  Future clearEntries(int feedId);
  /// Sets the [entry] read or unread depending on [read] flag.
  Future<FeedEntry> setRead(FeedEntry entry, [bool read = true]);
  
  //// UI methods.
  
  
  /// Refresing the feeds entries. It will send a signal to the background page to do the work. 
  void updateFeedData();
  
  /// Refresh the information about the feed represented by [feedId]. 
  void refreshFeed(String feedId);
  
  bool get isTrackingPermitted;
  
  set isTrackingPermitted(bool enabled);
}