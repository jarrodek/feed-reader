library rssapp.lists.feeditem;

import 'dart:html';

import 'package:polymer/polymer.dart';

import '../rss_database/dbstructures.dart';
/**
 * A class repreenting RSS/Atom list item.
 * Can have two states: unread or read.
 */
@CustomTag('rss-list-entry')
class RssListItemEntry extends PolymerElement {

  @published FeedEntry entry;
  RssListItemEntry.created() : super.created();
  
  void onStarChange(CustomEvent e, b, Element target) {
    e.preventDefault();
    e.stopImmediatePropagation();
    entry.starred = e.detail['starred']; 
    this.fire('star-change', detail: {'entry': entry});
  }

  void readPost(Event e) {
    e.preventDefault();
    e.stopImmediatePropagation();
    this.fire('read', detail: {'entry': entry});
  }

  String truncate(String input, [int length = 200, bool exact = false]) {
    if (input == null) return "";

    String ellipsis = '...';

    input = input.trim();
    int strlen = input.length;

    if (strlen <= length) {
      return input;
    }

    String truncate = input.substring(0, length - 3);
    if (!exact) {
      int lastSpacePos = truncate.lastIndexOf(new RegExp(' '));
      truncate = truncate.substring(0, lastSpacePos);
    }
    truncate = "$truncate$ellipsis";
    return truncate;
  }
  
  
}
