library rssapp.formatters.date;

import 'dart:html';
import 'package:intl/intl.dart';

import 'package:polymer/polymer.dart';
/**
 * A class repreenting RSS/Atom list item.
 * Can have two states: unread or read.
 */
@CustomTag('date-formatter')
class DateFormatter extends PolymerElement {

  @published String type = 'relativedate';
  @published String datetime;
  @observable String date;

  DateFormatter.created() : super.created();


  datetimeChanged() {
    if (datetime == null) return;
    _call();
  }

  _call() {
    switch (type) {
      case 'relativedate':
        _relativeDate();
        break;
      case 'relativeday':
        _relativeDay();
        break;
      case 'time':
        _time();
        break;
    }

  }
  
  
  
  void _relativeDate() {
    if(datetime == null) return;
    DateTime _date;
    try {
      _date = DateTime.parse(datetime);
    } catch (e) {
      return;
    }
    DateTime todayMidnight = midninght();
    
    if(todayMidnight.isBefore(_date)){
      date = "Today, at ${_date.hour}:${_date.minute}";
      return;
    }
    DateTime yesterdayMidnight = yesterdayMidninght(todayMidnight);
    if(yesterdayMidnight.isBefore(_date)){
      date = "Yesterday, at ${_date.hour}:${_date.minute}";
      return;
    }
    DateTime lastWeek = todayMidnight.subtract(new Duration(days:6));
    
    DateFormat formatter;
    if(lastWeek.isBefore(_date)){
      formatter = new DateFormat("on EEEE, 'at '");
    } else {
      formatter = new DateFormat.yMMMMd();
      formatter.addPattern("'at '", ', ');
    }
    formatter = formatter.add_Hm();
    date = formatter.format(_date);
  }
  
  void _relativeDay(){
    if(datetime == null) return;
    DateTime _date;
    try {
      _date = DateTime.parse(datetime);
    } catch (e) {
      return;
    }
    
    DateTime todayMidnight = midninght();
    if(todayMidnight.isBefore(_date)){
      date = "Today";
      return;
    }
    DateTime yesterdayMidnight = yesterdayMidninght(todayMidnight);
    if(yesterdayMidnight.isBefore(_date)){
      date = "Yesterday";
      return;
    }
    DateTime lastWeek = todayMidnight.subtract(new Duration(days:6));
    if(lastWeek.isBefore(_date)){
      DateFormat formatter = new DateFormat("EEEE");
      date = formatter.format(_date);
      return;
    }
    
    DateFormat formatter = new DateFormat(DateFormat.YEAR_NUM_MONTH_DAY); //new DateFormat("M/d/yy");
    date = formatter.format(_date);
  }
  
  _time(){
    if(datetime == null) return;
    DateTime _date;
    try {
      _date = DateTime.parse(datetime);
    } catch (e) {
      return;
    }
    var formatter = new DateFormat.jm();
    date = formatter.format(_date);
  }
  
  
  DateTime midninght() {
    DateTime now = new DateTime.now();
    return new DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
  }
  DateTime yesterdayMidninght([DateTime todayMidnight]) {
    if(todayMidnight == null){
      todayMidnight = midninght();
    }
    return todayMidnight.subtract(new Duration(days:1));
  }
}
