import 'package:intl/intl.dart';


class EventModel {
  final DateTime start;
  final DateTime end;
  final String summary;
  final String location;
  final bool exam; 

  EventModel({
    required this.start,
    required this.end,
    required this.summary,
    required this.location,
    required this.exam,
  });


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'summary': summary,
      'location': location,
      'exam': exam? 1 : 0,
    };
    return map;
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      start: DateTime.parse(map['start']),
      end: DateTime.parse(map['end']),
      summary: map['summary'],
      location: map['location'],
      exam: map['exam'] == 1,
    );
  }


  factory EventModel.fromICS(String icsData) {
    final lines = icsData.split('\n');
    DateTime? start;
    DateTime? end;
    String? summary;
    String? location;

    for (final line in lines) {
      if (line.startsWith('DTSTART')) {
        start = _parseDate(line.split(':')[1]);
      } else if (line.startsWith('DTEND')) {
        end = _parseDate(line.split(':')[1]);
      } else if (line.startsWith('SUMMARY')) {
        summary = line.split(':')[1];
      } else if (line.startsWith('LOCATION')) {
        location = line.split(':')[1];
      }
    }

    return EventModel(
      start: start!,
      end: end!,
      summary: summary!,
      location: location!,
      exam: false,
    );
  }

  static DateTime _parseDate(String date) {
    final regex = RegExp(r'(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})Z');
    final match = regex.firstMatch(date);
    if (match != null) {
      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);
      final hour = int.parse(match.group(4)!);
      final minute = int.parse(match.group(5)!);
      final second = int.parse(match.group(6)!);
      return DateTime.utc(year, month, day, hour, minute, second).toLocal();
    } else {
      throw FormatException('Invalid date format: $date');
    }
  }

  static DateTime parseApi(String date) {
    // Use a regular expression to extract the timestamp
    RegExp regExp = RegExp(r'/Date\((\d+)\)/');
    Match? match = regExp.firstMatch(date);
    
    if (match != null) {
      // Get the timestamp as a string
      String timestampStr = match.group(1)!;
      
      // Convert the timestamp to an integer
      int timestamp = int.parse(timestampStr);
      
      // Create a DateTime object using the timestamp (assuming it's in UTC)
      DateTime utcDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
      
      // Convert UTC DateTime to local time
      DateTime localDateTime = utcDateTime.toLocal();
      
      // Check if the date is in daylight saving time (DST)
      bool isDST = _isDaylightSavingTime(localDateTime);
      
      // Adjust the time according to DST
      if (isDST) {
        localDateTime = localDateTime.subtract(Duration(hours: 2));
      } else {
        localDateTime = localDateTime.subtract(Duration(hours: 1));
      }
      
      return localDateTime;
    } else {
      throw FormatException('Invalid date format');
    }
  }

  static bool _isDaylightSavingTime(DateTime date) {
    // Define the start and end dates of DST for a given year
    DateTime dstStart = DateTime(date.year, 3, 31 - (DateTime(date.year, 3, 31).weekday + 1) % 7);
    DateTime dstEnd = DateTime(date.year, 10, 31 - (DateTime(date.year, 10, 31).weekday + 1) % 7);
    
    return date.isAfter(dstStart) && date.isBefore(dstEnd);
  }
  static String getFormattedTitle(String title) {
    if (title.startsWith('[Óra]')) {
        title = title.substring(title.indexOf(']') + 2, title.length);
        var sv = title.split(" ");
        title = sv[0] + " " + sv[1];
    } 
    else if (title.startsWith('[Vizsga]')) {
        var sv = title.split(" ");
        title = sv[0] + " " + sv[1] + " " +sv[2];
    }

    
    return title;
  }
}
