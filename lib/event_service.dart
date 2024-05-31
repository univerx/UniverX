import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:univerx/features/calendar/data/model/calendarModel.dart';
import 'package:univerx/database/database_helper.dart';

class EventService {
  final String url;
  final now = DateTime(2024, 4, 30, 11, 30);
  EventService(this.url);

  Future<List<EventModel>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final icsData = response.body;
        final events = parseICS(icsData);
        events.sort((a, b) => a.start.compareTo(b.start)); // Sort events by start time
        return events;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('Error fetching events: $e');
      rethrow;
    }
  }

  List<EventModel> parseICS(String icsData) {
    try {
      final events = <EventModel>[];
      final eventStrings = icsData.split('BEGIN:VEVENT');
      for (var eventString in eventStrings.skip(1)) {
        events.add(EventModel.fromICS(eventString));
      }
      return events;
    } catch (e) {
      print('Error parsing ICS data: $e');
      rethrow;
    }
  }

  Future<EventModel?> getCurrentEvent() async {
    final events = await DatabaseHelper.instance.getAllEvents();
    // final now = DateTime.now(); //-------------------------------REMOVE COMMENT TO ENABLE LIVE TIME-----------------------------
    for (final event in events) {
      if (event.start.isBefore(now) && event.end.isAfter(now)) {
        return event;
      }
    }
    return null; // No event currently happening
  }

  Future<EventModel?> getUpcomingEvent() async {
    final events = await DatabaseHelper.instance.getAllEvents();
    // final now = DateTime.now();
    for (final event in events) {
      if (event.start.isAfter(now)) {
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

      final timeLeft = currentEvent.end.difference(now).inMinutes;
      return formatTimeLeft(timeLeft);
    }
    return null; // No event currently happening
  }

  Future<double?> percentagePassedOfCurrentEvent() async {
    final currentEvent = await getCurrentEvent();
    if (currentEvent != null) {
      //final now = DateTime.now(); //-------------------------------REMOVE COMMENT TO ENABLE LIVE TIME-----------------------------

      final duration = currentEvent.end.difference(currentEvent.start).inMinutes;
      final timePassed = now.difference(currentEvent.start).inMinutes;
      final percentagePassed = timePassed / duration;
      return percentagePassed;
    }
    return null; // No event currently happening
  }
 
}
