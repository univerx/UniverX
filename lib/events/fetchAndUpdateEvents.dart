import 'dart:io';
import 'package:univerx/models/eventModel.dart';
import 'package:univerx/database_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:univerx/event_service.dart';

Future<void> fetchAndUpdateEventsFromIcs(String filePath) async {
  final eventService = EventService('https://neptun-web2.tr.pte.hu/hallgato/cal/cal.ashx?id=BB24FE2D35D43417A71C81D956920C8F1EEF975C7C8D75F121B7BAD54821D0977171BBD64EDB3A10.ics');

  // Fetch events from .ics file
  List<EventModel> newEvents = await eventService.fetchEvents();

  // Fetch existing events from database
  DatabaseHelper dbHelper = DatabaseHelper.instance;


  // Clear the existing events in the database
  await dbHelper.clearAllEvents();

  // Save new events to the database
  for (EventModel newEvent in newEvents) {
    await dbHelper.saveEvent(newEvent);
  }
}
