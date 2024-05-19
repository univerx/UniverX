import 'package:flutter/material.dart';
import 'package:univerx/database_helper.dart';
import 'package:univerx/models/examModel.dart';
import 'package:univerx/models/assignmentModel.dart';
import 'package:univerx/models/noteModel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ExamModel> _exams = [];
  List<AssignmentModel> _assignments = [];
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadExams();
    _loadAssignments();
    _loadNotes();
  }

  Future<void> _loadExams() async {
    final exams = await DatabaseHelper.instance.getExams();
    setState(() {
      _exams = exams;
    });
  }

  Future<void> _loadAssignments() async {
    final assignments = await DatabaseHelper.instance.getAssignments();
    setState(() {
      _assignments = assignments;
    });
  }

  Future<void> _loadNotes() async {
    final notes = await DatabaseHelper.instance.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "UniX-PTE-TTK",
                style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 2,
                    // ---------------------------------- upcoming classes/event
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Color.fromARGB(255, 45, 45, 45),
                      ),
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Programozás II.",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  "f/201",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5), // Add some space between the row and the text below
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "→ Számítógép hálózatok",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  "C/V/I",
                                  style: TextStyle(
                                    color: Colors.white,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end, // Align the text to the right
                            children: [
                              Text(
                                "Time left: 1 hour 20 min", // Display the time left text
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 10,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey[300], // Background color of the progress bar
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                              borderRadius: BorderRadius.circular(20), // Color of the progress indicator
                              value: 0.8, // Value between 0.0 and 1.0 representing the progress
                            ),
                          )
                           // Add some space between the text and the progress bar
                        ],
                      ),
                      // Content of the first container
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 5),
                  // ---------------------------------- upcoming zh/ tests
                  Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/zh'),
                        child: Container(
                          padding: const EdgeInsets.only(top: 15),
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color.fromARGB(255, 45, 45, 45),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, // Center align the text
                            children: [
                              const Text(
                                "ZH",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Display the list of exams
                              ..._exams.map((exam) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          exam.name,
                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                          textAlign: TextAlign.left, // Left align the subject text
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 120, 120, 120),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          exam.getFormattedDate(),
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center, // Center align the date text
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  // ---------------------------------- upcoming assignments
                  Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/assignments'),
                        child: Container(
                          padding: const EdgeInsets.only(top: 15),
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color.fromARGB(255, 45, 45, 45),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, // Center align the text
                            children: [
                              const Text(
                                "Assignments",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Display the list of assignments
                              ..._assignments.map((assignment) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          assignment.name,
                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                          textAlign: TextAlign.left, // Left align the subject text
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 120, 120, 120),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          assignment.getFormattedDate(),
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center, // Center align the date text
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),



              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 5),
                  // ---------------------------------- notes
                  Expanded(
                    flex: 2,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/notes'),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          height: 600, // 300
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Color.fromARGB(255, 45, 45, 45),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, // Center align the text
                            children:[
                              const Text(
                                "Notes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Display the list of notes
                              ..._notes.map((note) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          note.title,
                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                          textAlign: TextAlign.left, // Left align the subject text
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 120, 120, 120),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          note.content,
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center, // Center align the date text
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ]
                          )
                        ),
                      )
                    )
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
