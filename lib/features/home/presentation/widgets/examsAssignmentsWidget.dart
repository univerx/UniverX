import 'package:flutter/material.dart';
import 'package:univerx/features/exams/data/model/examModel.dart';
import 'package:univerx/features/assignments/data/model/assignmentModel.dart';

class ExamsAssignmentsWidget extends StatelessWidget {
  final String title;
  final List<ExamModel>? exams;
  final List<AssignmentModel>? assignments;
  final String routeName;
  final BuildContext homeContext;

  ExamsAssignmentsWidget({
    required this.title,
    this.exams,
    this.assignments,
    required this.routeName,
    required this.homeContext,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(homeContext, routeName),
          child: Container(
            padding: const EdgeInsets.only(top: 15),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Color.fromARGB(255, 20, 21, 27),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 163, 172, 222),
                    fontSize: 26.0,
                    fontFamily: "sfpro",
                  ),
                  textAlign: TextAlign.center,
                ),
                ..._buildListItems(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildListItems() {
    final items = exams ?? assignments ?? [];
    return items.take(3).map((item) {
      final name = item is ExamModel ? item.name : (item as AssignmentModel).name;
      final formattedDate = item is ExamModel
          ? item.getFormattedDate()
          : (item as AssignmentModel).getFormattedDate();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 10),
            Expanded(
              child: Text(
                name.substring(0,10),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'sfpro',
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(width: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 35, 37, 48),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                formattedDate,
                style: const TextStyle(
                  color: Color.fromARGB(255, 163, 172, 222),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 5),
          ],
        ),
      );
    }).toList();
  }
}
