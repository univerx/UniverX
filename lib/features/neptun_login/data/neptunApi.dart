import 'dart:io';
import 'package:univerx/features/calendar/data/model/calendarModel.dart';
import 'package:univerx/database/database_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:univerx/event_service.dart';


Future<bool?> checkLoginDetails(String url, String neptunCode, String password) async {

  DatabaseHelper dbHelper = DatabaseHelper.instance;

  List<EventModel> newEvents = await fetchCalendar(url, neptunCode, password);
  if (newEvents.isEmpty) {
    return false;
  }

  await dbHelper.clearAllEvents();

  for (EventModel newEvent in newEvents) {
    await dbHelper.saveEvent(newEvent);
  }
  return true;
}

Future<void> fetchAndUpdateApi() async {
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  dbHelper.getNeptunLogin().then((loginDetails) async {
    if (loginDetails != null) {
      var details = loginDetails as Map<String, dynamic>;
      List<EventModel> newEvents = await fetchCalendar(details['url'], details['login'], details['password']);
      
      await dbHelper.clearAllEvents();

      for (EventModel newEvent in newEvents) {
        await dbHelper.saveEvent(newEvent);
      }
      return true;
    }
    else{
      return false;
    }
  });
}

Future<List<EventModel>> fetchCalendar(String url, String neptunCode, String password) async {
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

    return parseICS(data);
    // Dolgozd fel a data változót itt
  } else {
    print("Failed to load calendar data");
    return [];
  }
}


List<EventModel> parseICS(final jsonData) {
  final events = <EventModel>[];
  if (jsonData['calendarData'] != null && jsonData['calendarData'] is List) {
    for (var item in jsonData['calendarData']) {
      events.add(EventModel(
        start: EventModel.parseApi(item['start']),
        end: EventModel.parseApi(item['end']),
        summary: item['title'],
        location: item['location'],
        exam: item['title'].toString().startsWith("[Vizsga]"),
      ));
    }
  } else {
    print('No calendar data found.');
  }
  return events;
  
}