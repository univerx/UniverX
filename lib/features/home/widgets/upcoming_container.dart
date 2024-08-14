import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:univerx/features/calendar/calendarPage.dart';
import 'package:univerx/features/common/widgets/box_3d.dart';

class UpcomingContainer extends StatelessWidget {
  final BuildContext homeContext;
  final String title;
  final String date;
  final bool isExam; // Indicates if it's an exam
  final Function onDelete; // Callback for delete action
  final Function onEdit; // Callback for edit action

  UpcomingContainer({
    required this.homeContext,
    required this.title,
    required this.date,
    required this.isExam,
    required this.onDelete, // Initialize the delete callback
    required this.onEdit, // Initialize the edit callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showEditDeleteOptions(context);
      },
      child: Dismissible(
        key: Key(title),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (direction) {
          onDelete();
        },
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          height: 52,
          decoration: Box3D(),
          child: Container(
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 38, 51, 70),
            ),
            padding: EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  isExam ? Icons.school_rounded : Icons.assignment_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDeleteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
