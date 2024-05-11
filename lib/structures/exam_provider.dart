// exam_provider.dart

import 'package:flutter/material.dart';
import 'exam.dart';

class ExamProvider extends ChangeNotifier {
  List<Exam> exams = [];

  void addExam(Exam exam) {
    exams.add(exam);
    notifyListeners();
  }

  String DateFormat(rawDate) {
    rawDate = rawDate.split(" ")[0];
    rawDate = rawDate.split("-");
    // rawDate = [2022, 12, 31], count how many days left

    return rawDate[1] +"."+ rawDate[2]; 
  }
  String DaysLeft(rawDate){
    rawDate = rawDate.split(" ")[0];
    rawDate = rawDate.split("-");
    // rawDate = [2022, 12, 31], count how many days left
    var days_left = DateTime(int.parse(rawDate[0]), int.parse(rawDate[1]), int.parse(rawDate[2])).difference(DateTime.now()).inDays;

    return "(in "+days_left.toString() +" days)";
  }
}
