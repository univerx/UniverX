import 'package:intl/intl.dart';

class Exam {
  final int? id;
  final int classId;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final bool isUserCreated;

  Exam({this.id, required this.classId, required this.title, required this.description, required this.startTime, required this.endTime, required this.location, required this.isUserCreated});

  // Convert an Exam into a Map.
  Map<String, dynamic> toMap() {
    return {
      'exam_id': id,
      'class_id': classId,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location': location,
      'is_user_created': isUserCreated ? 1 : 0,
    };
  }

  // Convert a Map into an Exam.
  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['exam_id'],
      classId: map['class_id'],
      title: map['title'],
      description: map['description'],
      startTime: DateTime.parse(map['start_time']),
      endTime: DateTime.parse(map['end_time']),
      location: map['location'],
      isUserCreated: map['is_user_created'] == 1,
    );
  }
  String getFormattedDate() {
    final DateFormat formatter = DateFormat('MMM d');
    return formatter.format(startTime);
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
