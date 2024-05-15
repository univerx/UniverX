import 'package:intl/intl.dart';


class ExamModel {
  final int? id;
  final String name;
  final DateTime date;

  ExamModel({this.id, required this.name, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
    };
  }

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    return ExamModel(
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
