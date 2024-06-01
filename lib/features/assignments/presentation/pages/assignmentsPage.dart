import 'package:flutter/material.dart';
import 'package:univerx/features/home/presentation/pages/homePage.dart';
import 'package:univerx/features/assignments/data/model/assignmentModel.dart';
import 'package:univerx/database/database_helper.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';

class Assignments extends StatefulWidget {
  const Assignments({Key? key}) : super(key: key);

  @override
  _AssignmentsState createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
  List<AssignmentModel> _assignments = [];

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    final assignments = await DatabaseHelper.instance.getAssignments();
    setState(() {
      _assignments = assignments;
    });
  }

  void _addAssignment() async {
    final assignment = await showDialog<AssignmentModel>(
      context: context,
      builder: (BuildContext context) {
        String assignmentName = '';
        DateTime? assignmentDate;

        return AlertDialog(
          title: Text('Add Assignment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  assignmentName = value;
                },
                decoration: InputDecoration(labelText: 'Assignment Name'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  setState(() {
                    assignmentDate = selectedDate;
                  });
                },
                child: Text(assignmentDate == null ? 'Select Date' : 'Date: ${assignmentDate.toString().substring(0, 10)}'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (assignmentName.isNotEmpty && assignmentDate != null) {
                  Navigator.pop(context, AssignmentModel(name: assignmentName, date: assignmentDate!));
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
    if (assignment != null) {
      await DatabaseHelper.instance.insertAssignment(assignment);
      _loadAssignments(); // Refresh the list of assignments
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: DefaultAppBar(
        title: "UniX-Assignments",
        showBackButton: true,
      ),

      endDrawer: const DrawerMenu(), //Profile_menu pop up

      body: ListView.builder(
        itemCount: _assignments.length,
        itemBuilder: (context, index) {
          final assignment = _assignments[index];
          return ListTile(
            title: Text(assignment.name, style: TextStyle(color: Colors.white)),
            subtitle: Text(
              'Date: ${assignment.date.toLocal().toString().substring(0, 10)}',
              style: TextStyle(color: Colors.white70),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                await DatabaseHelper.instance.deleteAssignment(assignment.id!);
                _loadAssignments(); // Refresh the list of assignments
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAssignment,
        child: Icon(Icons.add),
      ),
      
    );
  }
}
