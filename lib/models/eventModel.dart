import 'package:intl/intl.dart';


class EventModel {
  final DateTime start;
  final DateTime end;
  final String summary;
  final String location;

  EventModel({
    required this.start,
    required this.end,
    required this.summary,
    required this.location,
  });


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'summary': summary,
      'location': location,
    };
    return map;
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      start: DateTime.parse(map['start']),
      end: DateTime.parse(map['end']),
      summary: map['summary'],
      location: map['location'],
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
}
