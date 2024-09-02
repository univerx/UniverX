import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:univerx/database/database_helper.dart';
import 'package:univerx/models/class.dart';
import 'package:univerx/models/exam.dart';
import 'package:univerx/services/neptun_API_fetching.dart';
import 'package:univerx/database/appdata.dart';


class ParsedData {
  final List<Class> classes;
  final List<Exam> exams;

  ParsedData({required this.classes, required this.exams});
}

class EventService {
  final String url;
  var now;
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
    CurrentTime time = CurrentTime();
    now = time.get_time();
    final events = await DatabaseHelper.instance.getClasses();
    for (final event in events) {
      if (event.startTime.isBefore(now) && event.endTime.isAfter(now)) {
        event.title = formatText(20, event.title);
        return event;      }
    }
    return null; // No event currently happening
  }

  Future<Class?> getUpcomingEvent() async {
    CurrentTime time = CurrentTime();
    now = time.get_time();
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

  String formatTimeLeft(int minutes, bool current) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    String prefix = current ? 'Ends in: ' : 'Starts in:';
    if (hours == 0) {
      return '${prefix} ${mins}m';
    }
    return '${prefix} ${hours}h ${mins}m';
  }

  Future<String?> timeLeftForCurrentEvent() async {
    CurrentTime time = CurrentTime();
    now = time.get_time();
    final currentEvent = await getCurrentEvent();
    final upcomingEvent = await getUpcomingEvent();
    if (currentEvent != null) {
      final timeLeft = currentEvent.endTime.difference(now).inMinutes;
      return formatTimeLeft(timeLeft, true);
    }
    else if(upcomingEvent != null) {
      final timeLeft = upcomingEvent.startTime.difference(now).inMinutes;
      return formatTimeLeft(timeLeft, false);
    }
    return null; // No event currently happening
  }

  Future<double?> percentagePassedOfCurrentEvent() async {
    CurrentTime time = CurrentTime();
    now = time.get_time();
    final currentEvent = await getCurrentEvent();
    final upcomingEvent = await getUpcomingEvent();
    if (currentEvent != null) {
      final duration = currentEvent.endTime.difference(currentEvent.startTime).inMinutes;
      final timePassed = now.difference(currentEvent.startTime).inMinutes;
      final percentagePassed = timePassed / duration;
      return percentagePassed;
    }
    else if (upcomingEvent != null) {
      // time till upcoming event start, from last class, if there is no class, from 8:00
      final timeTillNextClass = upcomingEvent.startTime.difference(now).inMinutes;
      final timeTillNextClassFrom8 = upcomingEvent.startTime.difference(DateTime(now.year, now.month, now.day, 8, 0)).inMinutes;
      final percentagePassed = 1 - timeTillNextClass / timeTillNextClassFrom8;
      return percentagePassed;
      
    }
    return null; // No event currently happening
  }
 
}
