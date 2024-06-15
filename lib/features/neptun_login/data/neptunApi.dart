import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:univerx/features/calendar/data/model/calendarModel.dart';
import 'package:univerx/database/database_helper.dart';


Future<List<EventModel>> fetchCalendar(String neptunCode, String userLogin, String password) async {
  final url = Uri.parse('https://neptun-web3.tr.pte.hu/hallgato/MobileService.svc/GetCalendarData');
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
    'UserLogin': userLogin,
    'Password': password,
    'NeptunCode': neptunCode,
    'CurrentPage': 0,
    'StudentTrainingID': null,
    'LCID': 1038,
    'ErrorMessage': null,
    'MobileVersion': '1.5',
    'MobileServiceVersion': 0
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return parseICS(data);
    // Dolgozd fel a data változót itt
  } else {
    throw Exception('Failed to load calendar data');
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
      ));
    }
  } else {
    print('No calendar data found.');
  }
  return events;
  
}