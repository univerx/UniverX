// exam_provider.dart

import 'package:flutter/material.dart';
import 'exam.dart';

class ExamProvider extends ChangeNotifier {
  List<Exam> exams = [];

  void addExam(Exam exam) {
    exams.add(exam);
    notifyListeners();
  }
}
