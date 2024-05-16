import 'package:intl/intl.dart';


class AssignmentModel {
  final int? id;
  final String name;
  final DateTime date;

  AssignmentModel({this.id, required this.name, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
    };
  }

  factory AssignmentModel.fromMap(Map<String, dynamic> map) {
    return AssignmentModel(
      id: map['id'],
      name: map['name'],
      date: DateTime.parse(map['date']),
    );
  }

  String getFormattedDate() {
    final DateFormat formatter = DateFormat('MMM d');
    return formatter.format(date);
  }
}
