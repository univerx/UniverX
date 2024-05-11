import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:univerx/pages/home.dart';
import 'package:univerx/structures/exam.dart';
import 'package:univerx/structures/exam_provider.dart';

void main() {
  runApp(Zh());
}

class Zh extends StatefulWidget {
  const Zh({Key? key}) : super(key: key);

  @override
  _ZhState createState() => _ZhState();
}

class _ZhState extends State<Zh> {

  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Exam Manager",
            style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
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
          itemCount: examProvider.exams.length,
          itemBuilder: (context, index) {
            final exam = examProvider.exams[index];
            return ListTile(
              title: Text(exam.name), textColor: Color.fromARGB(255, 255, 255, 255),
              subtitle: Text('Date: ${examProvider.DateFormat(exam.date.toString())} ${examProvider.DaysLeft(exam.date.toString())}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    examProvider.exams.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addExam(examProvider);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
  
  void _addExam(examProvider) async {
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
                  Navigator.pop(context, Exam(examName, examDate!));
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
    if (exam != null) {
      setState(() {
        examProvider.addExam(exam);
      });
    }
  }
}
