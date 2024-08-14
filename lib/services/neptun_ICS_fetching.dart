import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:univerx/database/database_helper.dart';
import 'package:univerx/models/class.dart';

class EventService {
  final String url;
  //final now = DateTime(2024, 4, 30, 11, 30);
  final now = DateTime.now();
  EventService(this.url);

  Future<void> fetchAndUpdateIcs(String filePath) async {
  final eventService = EventService(filePath);

  // Fetch events from .ics file
  List<Class> newEvents = await eventService.fetchEvents();
  if (newEvents.isEmpty) {
    return;
  }

  // Fetch existing events from database
  DatabaseHelper dbHelper = DatabaseHelper.instance;


  // Clear the existing events in the database
  await dbHelper.deleteNeptunClasses();

  // Save new events to the database
  for (Class newEvent in newEvents) {
    await dbHelper.insertClass(newEvent);
  }
}

  Future<List<Class>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final icsData = response.body;
        final events = parseICS(icsData);
        events.sort((a, b) => a.startTime.compareTo(b.startTime)); // Sort events by start time
        return events;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  List<Class> parseICS(String icsData) {
    try {
      final events = <Class>[];
      final eventStrings = icsData.split('BEGIN:VEVENT');
      for (var eventString in eventStrings.skip(1)) {
        events.add(Class.fromICS(eventString));
      }
      return events;
    } catch (e) {
      print('Error parsing ICS data: $e');
      rethrow;
    }
  }

  Future<Class?> getCurrentEvent() async {
    final events = await DatabaseHelper.instance.getClasses();
    // final now = DateTime.now(); //-------------------------------REMOVE COMMENT TO ENABLE LIVE TIME-----------------------------
    for (final event in events) {
      if (event.startTime.isBefore(now) && event.endTime.isAfter(now)) {
        return event;
      }
    }
    return null; // No event currently happening
  }

  Future<Class?> getUpcomingEvent() async {
    final events = await DatabaseHelper.instance.getClasses();
    // final now = DateTime.now();
    for (final event in events) {
      if (event.startTime.isAfter(now)) {
        return event;
      }
    }
    return null; // No upcoming events
  }
  String formatTimeLeft(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins}m';
  }

  Future<String?> timeLeftForCurrentEvent() async {
    final currentEvent = await getCurrentEvent();
    if (currentEvent != null) {
      // final now = DateTime.now(); //-------------------------------REMOVE COMMENT TO ENABLE LIVE TIME-----------------------------

      final timeLeft = currentEvent.endTime.difference(now).inMinutes;
      return formatTimeLeft(timeLeft);
    }
    return null; // No event currently happening
  }

  Future<double?> percentagePassedOfCurrentEvent() async {
    final currentEvent = await getCurrentEvent();
    if (currentEvent != null) {
      //final now = DateTime.now(); //-------------------------------REMOVE COMMENT TO ENABLE LIVE TIME-----------------------------

      final duration = currentEvent.endTime.difference(currentEvent.startTime).inMinutes;
      final timePassed = now.difference(currentEvent.startTime).inMinutes;
      final percentagePassed = timePassed / duration;
      return percentagePassed;
    }
    return null; // No event currently happening
  }
 
}
