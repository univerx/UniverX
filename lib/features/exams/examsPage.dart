import 'package:flutter/material.dart';
import 'package:univerx/database/database_helper.dart';
import 'package:univerx/models/exam.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';

void main() {
  runApp(Zh());
}

class Zh extends StatefulWidget {
  const Zh({Key? key}) : super(key: key);

  @override
  _ZhState createState() => _ZhState();
}

class _ZhState extends State<Zh> {
  List<Exam> _exams = [];

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  Future<void> _loadExams() async {
    final exams = await DatabaseHelper.instance.getExams();
    setState(() {
      _exams = exams;
    });
  }

  void _addExam() async {
    final exam = await showDialog<Exam>(
      context: context,
      builder: (BuildContext context) {
        String examName = '';
        DateTime? examDate;

        return AlertDialog(
          title: Text('Add Exam'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  examName = value;
                },
                decoration: InputDecoration(labelText: 'Exam Name'),
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
                    examDate = selectedDate;
                  });
                },
                child: Text(examDate == null ? 'Select Date' : 'Date: ${examDate.toString().substring(0, 10)}'),
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
                if (examName.isNotEmpty && examDate != null) {
                  Navigator.pop(context, Exam(
                    classId: -1, // ----------- TODO: Implement classId ----------------
                    title: examName,
                    description: "",
                    startTime: examDate!,
                    endTime: examDate!,
                    location: "",
                    isUserCreated: true
                  ));
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
    if (exam != null) {
      await DatabaseHelper.instance.insertExam(exam);
      _loadExams(); // Refresh the list of exams
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: const DrawerMenu(), //Profile_menu pop up
      body: CustomScrollView(
        slivers: <Widget>[
          DefaultAppBar(
            title: "UniX-Exams",
            showBackButton: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _exams.length,
                  itemBuilder: (context, index) {
                    final exam = _exams[index];
                    return ListTile(
                      title: Text(exam.title, style: TextStyle(color: Colors.white)),
                      subtitle: Text(
                        'Date: ${exam.startTime.toLocal().toString().substring(0, 10)}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.white),
                        onPressed: () async {
                          await DatabaseHelper.instance.deleteExam(exam.id!);
                          _loadExams(); // Refresh the list of exams
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExam,
        child: Icon(Icons.add),
      ),
    );
  }
}
