import 'package:flutter/material.dart';
import 'package:univerx/pages/home.dart';
import 'package:univerx/models/examModel.dart';
import 'package:univerx/database_helper.dart';

void main() {
  runApp(Zh());
}

class Zh extends StatefulWidget {
  const Zh({Key? key}) : super(key: key);

  @override
  _ZhState createState() => _ZhState();
}

class _ZhState extends State<Zh> {
  List<ExamModel> _exams = [];

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  Future<void> _loadExams() async {
    final exams = await DatabaseHelper.instance.getExams();
    setState(() {
      _exams = exams
        ..sort((a, b) => a.date.compareTo(b.date)); // Sort exams by date
    });
  }

  void _addExam() async {
    final exam = await showDialog<ExamModel>(
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
                child: Text(examDate == null
                    ? 'Select Date'
                    : 'Date: ${examDate.toString().substring(0, 10)}'),
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
                  Navigator.pop(
                      context, ExamModel(name: examName, date: examDate!));
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Exam Manager",
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
        ),
        body: ListView.builder(
          itemCount: _exams.length,
          itemBuilder: (context, index) {
            final exam = _exams[index];
            return ListTile(
              title: Text(exam.name, style: TextStyle(color: Colors.white)),
              subtitle: Text(
                'Date: ${exam.date.toLocal().toString().substring(0, 10)}',
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
        floatingActionButton: FloatingActionButton(
          onPressed: _addExam,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
