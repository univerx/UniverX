import 'dart:io';
import 'package:univerx/features/calendar/data/model/calendarModel.dart';
import 'package:univerx/database/database_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:univerx/event_service.dart';
import 'package:univerx/features/neptun_login/data/neptunApi.dart';

Future<void> fetchAndUpdateApi() async {
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  dbHelper.getNeptunLogin().then((loginDetails) async {
    if (loginDetails != null) {
      var details = loginDetails as Map<String, dynamic>;
      List<EventModel> newEvents = await fetchCalendar(details['url'], details['login'], details['password']);
      // Fetch existing events from database


      // Clear the existing events in the database
      await dbHelper.clearAllEvents();

      // Save new events to the database
      for (EventModel newEvent in newEvents) {
        await dbHelper.saveEvent(newEvent);
      }
    }
  });


  
}
