import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:univerx/database/database_helper.dart';
import 'package:univerx/models/class.dart';
import 'package:univerx/models/exam.dart';
import 'package:univerx/services/neptun_API_fetching.dart';

class ParsedData {
  final List<Class> classes;
  final List<Exam> exams;

  ParsedData({required this.classes, required this.exams});
}

class EventService {
  final String url;
  final now = DateTime.now();
  EventService(this.url);

  Future<void> fetchAndUpdateIcs() async {

    // Fetch events from .ics file
    ParsedData newEvents = await fetchEvents();
    if (newEvents.classes.isEmpty && newEvents.exams.isEmpty) {
      return;
    }

    //classes and exams
    List<Class> newClasses = newEvents.classes;
    List<Exam> newExams = newEvents.exams;
    print(newExams);
    print(newClasses);

    // Fetch existing events from database
    DatabaseHelper dbHelper = DatabaseHelper.instance;


    // Clear the existing events in the database
    await dbHelper.deleteNeptunClasses();
    await dbHelper.deleteNeptunExams();

    // Save new events to the database
    for (Class newEvent in newClasses) {
      await dbHelper.insertClass(newEvent);
    }
    for (Exam newExam in newExams) {
      await dbHelper.insertExam(newExam);
    }
  }

  Future<ParsedData> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final icsData = response.body;
        ParsedData parsed = parseICS(icsData);
        parsed.exams.sort((a, b) => a.startTime.compareTo(b.startTime)); // Sort events by start time
        parsed.classes.sort((a, b) => a.startTime.compareTo(b.startTime)); // Sort events by start time


        return parsed;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('Error fetching events: $e');
      return null!;
    }
  }

  ParsedData parseICS(String icsData) {
    try {
      ParsedData parsedData = ParsedData(classes: [], exams: []);
      final eventStrings = icsData.split('BEGIN:VEVENT');
      for (var eventString in eventStrings.skip(1)) {
        // if object type exam add to exam else add to event
        final event = Class.fromICS(eventString);
        if (event.runtimeType == Exam) {
          parsedData.exams.add(event as Exam);
        }
        else if (event.runtimeType == Class) {
          parsedData.classes.add(event as Class);
        }
      }
      return parsedData;
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
        event.title = formatText(20, event.title);
        return event;      }
    }
    return null; // No event currently happening
  }

  Future<Class?> getUpcomingEvent() async {
    var events = await DatabaseHelper.instance.getClasses();
    for (final event in events) {
      if (event.startTime.isAfter(now)) {
        event.title = formatText(30, event.title);
        return event;
      }
    }
    return null; // No upcoming events
  }

  static String formatText(int limit, String text) {
    var words = text.split(' ');
    var result = '';  

    if (words[0].length > limit){
      return  words[0].substring(0,limit-3) + "...";
    }


    for (var word in words) {
      if (result.length + word.length <= limit) {
        result += word + ' ';
      } else {
        //result += '...';
        break;
      }
    }
    //if last character is a comma, remove it
    if (result[result.length - 2] == ',') {
      result = result.substring(0, result.length - 2);
    }
    return result;
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
