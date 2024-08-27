import 'package:intl/intl.dart';
import 'package:univerx/models/exam.dart';

class Class {
  final int id;
  late String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final int instructorId;
  final bool isUserCreated;

  Class({required this.id, required this.title, required this.description, required this.startTime, required this.endTime, required this.location, required this.instructorId, required this.isUserCreated});

  // Convert a Class into a Map.
  Map<String, dynamic> toMap() {
    return {
      'class_id': id,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location': location,
      'instructor_id': instructorId,
      'is_user_created': isUserCreated ? 1 : 0,
    };
  }

  // Convert a Map into a Class.
  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
      id: map['class_id'],
      title: map['title'],
      description: map['description'],
      startTime: DateTime.parse(map['start_time']),
      endTime: DateTime.parse(map['end_time']),
      location: map['location'],
      instructorId: map['instructor_id'],
      isUserCreated: map['is_user_created'] == 1,
    );
  }

  // ------------------ Helper functions ------------------
  static Object fromICS(String icsData) {
    final lines = icsData.split('\n');
    DateTime? startTime;
    DateTime? endTime;
    String? title;
    String? location;

    for (final line in lines) {
      if (line.startsWith('DTSTART')) {
        startTime = _parseDate(line.split(':')[1]);
      } else if (line.startsWith('DTEND')) {
        endTime = _parseDate(line.split(':')[1]);
      } else if (line.startsWith('SUMMARY')) {
        title = line.split(':')[1];
      } else if (line.startsWith('LOCATION')) {
        location = line.split(':')[1];
      }
    }
    //if title starts with vizsga return with Exam()
    if (title!.contains('Vizsga')) {
      return Exam(
        id: -1,
        classId: -1,
        title: title!,
        description: "",
        startTime: startTime!,
        endTime: endTime!,
        location: location!,
        isUserCreated: false,
      );
    }

    return Class(
      id: -1,
      title: title!,
      description: "",
      startTime: startTime!,
      endTime: endTime!,
      location: location!,
      instructorId: -1,
      isUserCreated: false,
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

  static DateTime parseApiTime(String date) {
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
