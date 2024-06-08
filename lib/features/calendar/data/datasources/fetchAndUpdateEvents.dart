import 'dart:io';
import 'package:univerx/features/calendar/data/model/calendarModel.dart';
import 'package:univerx/database/database_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:univerx/event_service.dart';

Future<void> fetchAndUpdateEventsFromIcs(String filePath) async {
  final eventService = EventService(filePath);

  // Fetch events from .ics file
  List<EventModel> newEvents = await eventService.fetchEvents();
  if (newEvents.isEmpty) {
    return;
  }

  // Fetch existing events from database
  DatabaseHelper dbHelper = DatabaseHelper.instance;


  // Clear the existing events in the database
  await dbHelper.clearAllEvents();

  // Save new events to the database
  for (EventModel newEvent in newEvents) {
    await dbHelper.saveEvent(newEvent);
  }
}
