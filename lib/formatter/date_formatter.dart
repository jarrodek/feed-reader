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
    DateTime todayMidnight = midninght();
    
    if(todayMidnight.isBefore(date)){
      return "Today, at ${date.hour}:${date.minute}";
    }
    DateTime yesterdayMidnight = yesterdayMidninght(todayMidnight);
    if(yesterdayMidnight.isBefore(date)){
      return "Yesterday, at ${date.hour}:${date.minute}";
    }
    DateTime lastWeek = todayMidnight.subtract(new Duration(days:6));
    
    DateFormat formatter;
    if(lastWeek.isBefore(date)){
      formatter = new DateFormat("on EEEE, 'at ");
    } else {
      formatter = new DateFormat.yMMMMd();
    }
    
    formatter = formatter.add_Hm();
    return formatter.format(date);
  }
  
}


@Formatter(name: 'relativeday')
class RelativeDayFilter {
  String call(DateTime date){
    if(date == null) return '';
    DateTime todayMidnight = midninght();
    if(todayMidnight.isBefore(date)){
      return "Today";
    }
    DateTime yesterdayMidnight = yesterdayMidninght(todayMidnight);
    if(yesterdayMidnight.isBefore(date)){
      return "Yesterday";
    }
    DateTime lastWeek = todayMidnight.subtract(new Duration(days:6));
    if(lastWeek.isBefore(date)){
      DateFormat formatter = new DateFormat("EEEE");
      return formatter.format(date);
    }
    
    DateFormat formatter = new DateFormat(DateFormat.YEAR_NUM_MONTH_DAY); //new DateFormat("M/d/yy");
    return formatter.format(date);
  }
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