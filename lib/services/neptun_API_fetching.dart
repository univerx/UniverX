import 'dart:io';
import 'package:univerx/database/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:univerx/models/exam.dart';
import 'dart:convert';
import 'package:univerx/services/neptun_ICS_fetching.dart';
import 'package:univerx/models/class.dart';

class ParsedData {
  final List<Class> events;
  final List<Exam> exams;

  ParsedData({required this.events, required this.exams});
}


Future<bool?> checkLoginDetails(String url, String neptunCode, String password) async {

  DatabaseHelper dbHelper = DatabaseHelper.instance;

  ParsedData parsed = await fetchCalendar(url, neptunCode, password);
  List<Class> newEvents = parsed.events;

  if (newEvents.isEmpty) {
    return false;
  }

  await dbHelper.deleteNeptunClasses();

  for (Class newEvent in newEvents) {
    await dbHelper.insertClass(newEvent);
  }
  return true;
}

Future<void> fetchAndUpdateApi() async {
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  dbHelper.getNeptunLogin().then((loginDetails) async {
    if (loginDetails != null) {
      var details = loginDetails as Map<String, dynamic>;

      ParsedData parsed = await fetchCalendar(details['url'], details['login'], details['password']);
      List<Class> newEvents = parsed.events;
      List<Exam> newExams = parsed.exams;      
      
      await dbHelper.deleteNeptunClasses();

      for (Class newEvent in newEvents) {
        await dbHelper.insertClass(newEvent);
      }
      
      await dbHelper.deleteNeptunExams();
      for (Exam newExam in newExams) {
        await dbHelper.insertExam(newExam);
      }
      return true;
    }
    else{
      return false;
    }
  });
}

Future<ParsedData> fetchCalendar(String url, String neptunCode, String password) async {
  final final_url = Uri.parse(url + "/GetCalendarData");
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'needAllDaylong': false,
    'TotalRowCount': -1,
    'ExceptionsEnum': 0,
    'Time': true,
    'Exam': true,
    'Task': true,
    'Apointment': true,
    'RegisterList': true,
    'Consultation': true,
    'startDate': "/Date(0000000000000)/",
    'endDate': "/Date(9999999999999)/",
    'entityLimit': 0,
    'UserLogin': neptunCode,
    'Password': password,
    'NeptunCode': neptunCode,
    'CurrentPage': 0,
    'StudentTrainingID': null,
    'LCID': 1038,
    'ErrorMessage': null,
    'MobileVersion': '1.5',
    'MobileServiceVersion': 0
  });

  final response = await http.post(final_url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return parseData(data);
    // Dolgozd fel a data változót itt
  } else {
    print("Failed to load calendar data");
    return ParsedData(events: [], exams: []);
  }
}


ParsedData parseData(final jsonData) {
  final events = <Class>[];
  final exams = <Exam>[];

  Map<String, int> classes = {};

  if (jsonData['calendarData'] != null && jsonData['calendarData'] is List) {
    //--------------------classes PARSING--------------------
    for (var item in jsonData['calendarData']) {
      String key = "-1";
      if (item['title'].startsWith('[Óra]')) {
        int startIndex = item['title'].indexOf('(');
        int endIndex = item['title'].indexOf(')', startIndex);
        if (startIndex != -1 && endIndex != -1) {
          key = item['title'].substring(startIndex + 1, endIndex);
          if (!classes.containsKey(key)) {
            classes[key] = classes.length;
          }
          events.add(Class(
            id: classes[key]!,
            title: item['title'],
            description: "",
            startTime: Class.parseApiTime(item['start']),
            endTime: Class.parseApiTime(item['end']),
            location: item['location'],
            instructorId: -1,
            isUserCreated: false,
          ));
        }
      }
    }

    //--------------------exams PARSING--------------------
    for (var item in jsonData['calendarData']) {
      String key = "-1";
      if (item['title'].startsWith('[Vizsga]')) {
        int startIndex = item['title'].indexOf('(');
        int endIndex = item['title'].indexOf(')', startIndex);
        if (startIndex != -1 && endIndex != -1) {
          key = item['title'].substring(startIndex + 1, endIndex);
          exams.add(Exam(
            classId: classes[key]!,
            title: item['title'],
            description: "",
            startTime: Class.parseApiTime(item['start']),
            endTime: Class.parseApiTime(item['end']),
            location: item['location'],
            isUserCreated: false,
          ));
        }
      }
    }
  } else {
    print('No calendar data found.');
  }

  return ParsedData(events: events, exams: exams);
}
