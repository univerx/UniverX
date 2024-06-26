import 'package:intl/intl.dart';
import 'package:univerx/models/class.dart';

class Assignment {
  final int? id;
  final int classId;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isUserCreated;

  Assignment({this.id, required this.classId, required this.title, required this.description, required this.dueDate, required this.isUserCreated});

  // Convert an Assignment into a Map.
  Map<String, dynamic> toMap() {
    return {
      'assignment_id': id,
      'class_id': classId,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'is_user_created': isUserCreated ? 1 : 0,
    };
  }

  // Convert a Map into an Assignment.
  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['assignment_id'],
      classId: map['class_id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['due_date']),
      isUserCreated: map['is_user_created'] == 1,
    );
  }
  String getFormattedDate() {
    final DateFormat formatter = DateFormat('MMM d');
    return formatter.format(dueDate);
  }

  Class convertAssignmentToClass() {
    return Class(
      id: classId,
      title: title,
      description: description,
      startTime: dueDate,
      endTime: dueDate.add(Duration(hours: 1)), // Assuming 1 hour duration for assignment due date
      location: '',
      instructorId: -1, // Or provide an appropriate value if available
      isUserCreated: isUserCreated,
    );
  }
}
