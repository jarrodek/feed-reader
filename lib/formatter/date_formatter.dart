library rssapp.formatter.dateformatter;

import 'package:intl/intl.dart';

import 'package:angular/angular.dart';

@Formatter(name: 'relativedate')
class RelativeDateFilter {
  String call(String dateStr){
    DateTime date;
    try{
      date = DateTime.parse(dateStr);
    } catch(e){
      return dateStr;
    }
    DateTime now = new DateTime.now();
    
    DateTime todayMidnight = new DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
    
    if(todayMidnight.isBefore(date)){
      return "Today, at ${date.hour}:${date.minute}";
    }
    DateTime yesterdayMidnight = todayMidnight.subtract(new Duration(days:1));
    if(yesterdayMidnight.isBefore(date)){
      return "Yesterday, at ${date.hour}:${date.minute}";
    }
    
    var formatter = new DateFormat.yMMMMd();
    formatter = formatter.add_Hm();
    
    return formatter.format(date);
  }
  
}