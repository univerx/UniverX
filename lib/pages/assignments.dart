import 'package:flutter/material.dart';
import 'package:univerx/pages/home.dart';
import 'package:univerx/models/assignmentModel.dart'; // Assuming you have a model for assignments
import 'package:univerx/database_helper.dart'; // Assuming you use the same database helper for assignments

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
    assignments.sort((a, b) => a.date.compareTo(b.date)); // Sort exams by date
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
                child: Text(assignmentDate == null
                    ? 'Select Date'
                    : 'Date: ${assignmentDate.toString().substring(0, 10)}'),
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
                  Navigator.pop(
                      context,
                      AssignmentModel(
                          name: assignmentName, date: assignmentDate!));
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Assignment Manager",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                // to second page
                //Navigator.pushNamed(context, '/second');
              },
              icon: const CircleAvatar(
                backgroundColor: Colors.blue, // Change the color as needed
                child: Text(
                  "D", // Replace with your letter
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: _assignments.length,
          itemBuilder: (context, index) {
            final assignment = _assignments[index];
            return ListTile(
              title:
                  Text(assignment.name, style: TextStyle(color: Colors.white)),
              subtitle: Text(
                'Date: ${assignment.date.toLocal().toString().substring(0, 10)}',
                style: TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () async {
                  await DatabaseHelper.instance
                      .deleteAssignment(assignment.id!);
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
      ),
    );
  }
}
