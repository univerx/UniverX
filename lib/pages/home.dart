import 'package:flutter/material.dart';
import 'package:univerx/database_helper.dart';
import 'package:univerx/models/examModel.dart';
import 'package:univerx/models/assignmentModel.dart';
import 'package:univerx/models/noteModel.dart';
import 'package:univerx/event_service.dart';
import 'package:univerx/models/eventModel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ExamModel> _exams = [];
  List<AssignmentModel> _assignments = [];
  List<Note> _notes = [];

  late Future<EventModel?> currentEvent;
  late Future<EventModel?> upcomingEvent;

  late Future<String?> timeLeftForEvent;
  late Future<double?> percentagePassedForEvent;

  final eventService = EventService('https://neptun-web2.tr.pte.hu/hallgato/cal/cal.ashx?id=BB24FE2D35D43417A71C81D956920C8F1EEF975C7C8D75F121B7BAD54821D0977171BBD64EDB3A10.ics');


  @override
  void initState() {
    super.initState();
    _loadExams();
    _loadAssignments();
    _loadNotes();

    currentEvent = eventService.getCurrentEvent();
    upcomingEvent = eventService.getUpcomingEvent();

    timeLeftForEvent = eventService.timeLeftForCurrentEvent();
    percentagePassedForEvent = eventService.percentagePassedOfCurrentEvent();
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
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
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
              // --------------------------- Classes and events ---------------------------
              Row(
                children: [
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 2,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/events'),
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
                                children: [
                                  FutureBuilder<EventModel?>(
                                    future: currentEvent,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      } else if (snapshot.hasData) {
                                        final event = snapshot.data;
                                        if (event != null) {
                                          return Text(
                                            '${event.summary.substring(0, 15)}',
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        } else {
                                          return Text('No event currently happening');
                                        }
                                      } else {
                                        return Text('No event currently happening');
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: FutureBuilder<EventModel?>(
                                      future: currentEvent,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error: ${snapshot.error}'));
                                        } else if (snapshot.hasData) {
                                          final event = snapshot.data;
                                          if (event != null) {
                                            return Text(
                                              '${event.location.split(" ").first}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          } else {
                                            return Text('-');
                                          }
                                        } else {
                                          return Text('-');
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  FutureBuilder<EventModel?>(
                                    future: upcomingEvent,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      } else if (snapshot.hasData) {
                                        final event = snapshot.data;
                                        if (event != null) {
                                          return Text(
                                            '→ ${event.summary.substring(0, 15)}',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white,
                                            ),
                                          );
                                        } else {
                                          return Text('No upcoming event.');
                                        }
                                      } else {
                                        return Text('No upcoming event.');
                                      }
                                    },
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: FutureBuilder<EventModel?>(
                                      future: upcomingEvent,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error: ${snapshot.error}'));
                                        } else if (snapshot.hasData) {
                                          final event = snapshot.data;
                                          if (event != null) {
                                            return Text(
                                              '${event.location.split(" ").first}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          } else {
                                            return Text('-');
                                          }
                                        } else {
                                          return Text('-');
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              FutureBuilder<String?>(
                                future: timeLeftForEvent,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData) {
                                    final timeLeft = snapshot.data;
                                    if (timeLeft != null) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Time left: ${timeLeft}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return const Text('No event currently happening');
                                    }
                                  } else {
                                    return const Text('No event currently happening');
                                  }
                                },
                              ),
                              const SizedBox(height: 5),
                              FutureBuilder<double?>(
                                future: percentagePassedForEvent,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData) {
                                    final percentagePassed = snapshot.data;
                                    if (percentagePassed != null) {
                                      return SizedBox(
                                        height: 10,
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.grey[300],
                                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                                          borderRadius: BorderRadius.circular(20),
                                          value: percentagePassed,
                                        ),
                                      );
                                    } else {
                                      return const Text('No event currently happening');
                                    }
                                  } else {
                                    return const Text('No event currently happening');
                                  }
                                },
                              ),
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
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Center align the text
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
                              ..._exams.take(3).map((exam) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          exam.name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                          textAlign: TextAlign
                                              .left, // Left align the subject text
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 120, 120, 120),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          exam.getFormattedDate(),
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign
                                              .center, // Center align the date text
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
                        onTap: () =>
                            Navigator.pushNamed(context, '/assignments'),
                        child: Container(
                          padding: const EdgeInsets.only(top: 15),
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color.fromARGB(255, 45, 45, 45),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Center align the text
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
                              ..._assignments.take(3).map((assignment) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          assignment.name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                          textAlign: TextAlign
                                              .left, // Left align the subject text
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 120, 120, 120),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          assignment.getFormattedDate(),
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign
                                              .center, // Center align the date text
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
                // ---------------------------------- notes
                children: [
                  SizedBox(width: 5),
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
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, // Center align the text
                                    children: [
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  note.title,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                  textAlign: TextAlign
                                                      .left, // Left align the subject text
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 120, 120, 120),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  note.content,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  textAlign: TextAlign
                                                      .center, // Center align the date text
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ])),
                          ))),
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
