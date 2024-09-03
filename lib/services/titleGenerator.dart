import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:univerx/database/appdata.dart';
import 'package:univerx/database/database_helper.dart';
import 'package:univerx/models/class.dart';

String welcomeGenerator() {
  CurrentTime time = CurrentTime();
  final now = time.get_time();
  // final now = DateTime(2024,09,03,03,00);

  var ttne = Duration(hours: 9); // needs to be fixed

  if (now.weekday == 6 || now.weekday == 7) {
    return "Kellemes hétvégét!";
  } else if (now.hour < 12 && now.hour > 5) {
    return "Jó reggelt!";
  } else if (now.hour < 18 && now.hour >= 12) {
    return "Kellemes délutánt!";
  } else {
    if (ttne != null) {
      if (ttne.inHours >= 9) {
        return "Jó estét!";
      } else if (ttne.inHours >= 8) {
        return "Jó éjszakát!";
      } else if (ttne.inHours >= 7) {
        return "Ideje aludni!";
      } else if (ttne.inHours >= 6) {
        return "Na tesoooo 😴";
      } else if (ttne.inHours >= 5) {
        return "Teso neeee!";
      } else {
        return "💀💀💀";
      }
    } else {
      return "Jó estét!";
    }
  }
}






  Future<DateTime?> getUpcomingEvent() async {
  CurrentTime time = CurrentTime();
  DateTime now = time.get_time();
  var events = await DatabaseHelper.instance.getClasses();
  for (final event in events) {
    if (event.startTime.isAfter(now)) {
      return event.startTime;
    }
  }
  return null; // No upcoming events
}

// Usage example:


