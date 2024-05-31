// ---------------------Flutter Packages--------------------------
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------------------Self Defined Packages--------------------------
import 'package:univerx/database_helper.dart';
import 'package:univerx/models/examModel.dart';
import 'package:univerx/models/assignmentModel.dart';
import 'package:univerx/models/noteModel.dart';
import 'package:univerx/event_service.dart';
import 'package:univerx/models/eventModel.dart';

import 'package:univerx/main.dart';

// ---------------------Other Packages--------------------------
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:vibration/vibration.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with RouteAware {
  // ---------------------Initialize Variables--------------------------
  List<ExamModel> _exams = [];
  List<AssignmentModel> _assignments = [];
  List<Note> _notes = [];

  late Future<EventModel?> currentEvent;
  late Future<EventModel?> upcomingEvent;

  late Future<String?> timeLeftForEvent;
  late Future<double?> percentagePassedForEvent;

  final eventService = EventService('');

  

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
  
  // ---------------------POP Observer To Refresh The Page--------------------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute as PageRoute);
    }
  }

  @override
  void didPopNext() {
    // This method is called when the current route has been popped
    // off, and the current route shows up again.
    _handleRefresh();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
  


  Future<void> _handleRefresh() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      HapticFeedback.heavyImpact();
    }
    await _loadExams();
    await _loadAssignments();
    await _loadNotes();
    await currentEvent;
    await upcomingEvent;
    await timeLeftForEvent;
    await percentagePassedForEvent;
    return await Future<void>.delayed(const Duration(seconds: 0, milliseconds: 500));
  }

  // ---------------------Home Page Builder--------------------------
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // Default text color
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.black,

        appBar: DefaultAppBar(
          title: "UniX-PTE-TTK",
          showBackButton: false,
        ),
        
        body: CustomMaterialIndicator(
          
          onRefresh: _handleRefresh,
          indicatorBuilder: (context, controller) {
            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 20, 21, 27), // Set the desired background color here
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            );
          },
          child: SingleChildScrollView(
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
                              color: Color.fromARGB(255, 20, 21, 27),
                              /*
                              gradient: LinearGradient(
                                end: Alignment.topLeft,
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.4),
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.2),
                                  Colors.white.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),*/
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
                                        color: Color.fromARGB(255, 35, 37, 48),
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
                                                  color: Color.fromARGB(255, 163, 172, 222),
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
                                                fontFamily: "sfpro"
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
                                        color: Color.fromARGB(255, 35, 37, 48),
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
                                                  color: Color.fromARGB(255, 163, 172, 222),
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
                                        return const Text('');
                                      }
                                    } else {
                                      return const Text('');
                                    }
                                  },
                                ),
                                const SizedBox(height: 5),
                                FutureBuilder<double?>(
                                  future: percentagePassedForEvent,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(child: Text('Error: ${snapshot.error}'));
                                    } else {
                                      var percentagePassed = snapshot.data;
                                      if (percentagePassed == null) {
                                        percentagePassed = 0;
                                      }
                                      return SizedBox(
                                        height: 10,
                                        child: LinearProgressIndicator(
                                          backgroundColor: Color.fromARGB(255,43,44,49),
                                          valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 255, 255)),
                                          borderRadius: BorderRadius.circular(20),
                                          value: percentagePassed,
                                        ),
                                      );
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
                              color: Color.fromARGB(255, 20, 21, 27),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Center align the text
                              children: [
                                const Text(
                                  "Exams",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 163, 172, 222),
                                    fontSize: 26.0,
                                    fontFamily: "sfpro"
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                // Display the list of exams
                                ..._exams.take(3).map((exam) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            exam.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'sfpro',
                                            ),
                                            textAlign: TextAlign.left, // Left align the subject text
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
                                            exam.getFormattedDate(),
                                            style: const TextStyle(
                                              color: Color.fromARGB(255, 163, 172, 222),
                                              fontWeight: FontWeight.bold,
                                            ),
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
                    SizedBox(width: 10),
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
                              color: Color.fromARGB(255, 20, 21, 27),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Center align the text
                              children: [
                                const Text(
                                  "Assignments",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 163, 172, 222),
                                    fontSize: 26.0,
                                    fontFamily: "sfpro"
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
                                              fontSize: 18,
                                              fontFamily: "sfpro"
                                            ),
                                            textAlign: TextAlign.left, // Left align the subject text
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 35, 37, 48),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            assignment.getFormattedDate(),
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 163, 172, 222),
                                              fontWeight: FontWeight.bold,
                                            ),
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
                // ---------------------------------- notes
                Row(
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
                                    color: Color.fromARGB(255, 20, 21, 27),
                                  ),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center, // Center align the text
                                      children: [
                                        const Text(
                                          "Notes",
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 163, 172, 222),
                                            fontSize: 23.0,
                                            fontFamily: "sfpro"
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
                                                      fontSize: 18,
                                                    ),
                                                    textAlign: TextAlign.left, // Left align the subject text
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
      ),
    );
  }
}
