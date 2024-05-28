class Event {
  final DateTime start;
  final DateTime end;
  final String summary;
  final String location;

  Event({
    required this.start,
    required this.end,
    required this.summary,
    required this.location,
  });

  factory Event.fromICS(String icsData) {
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

    return Event(
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
