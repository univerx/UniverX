import 'dart:async'; // Import for Timer
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

// ---------------------Self Defined Packages--------------------------
import 'package:univerx/database/database_helper.dart';
import 'package:univerx/features/appointment/OLD_appointmentPage.dart';
import 'package:univerx/features/home/widgets/upcoming_container.dart';
import 'package:univerx/services/neptun_ICS_fetching.dart';

import 'package:univerx/main.dart';

// ---------------------Models--------------------------
import 'package:univerx/models/assignment.dart';
import 'package:univerx/models/exam.dart';
import 'package:univerx/models/class.dart';

// ---------------------Other Packages--------------------------
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:vibration/vibration.dart';
import 'package:univerx/services/titleGenerator.dart';
import 'package:univerx/database/appdata.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/common/widgets/refresh_app_icon.dart';
import 'package:univerx/features/home/widgets/calendarWidget.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';
import 'package:univerx/features/home/widgets/horizontal_scrollable_menu.dart';
import 'package:univerx/features/common/widgets/custom_bottom_navigation_bar.dart';

import 'package:univerx/features/appointment/appointmentManager.dart';

import 'package:intl/intl.dart'; // Add this package for date formatting

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver, RouteAware {
  // ---------------------Initialize Variables--------------------------
  List<Exam> _exams = [];
  List<Assignment> _assignments = [];

  late Future<Class?> currentEvent;
  late Future<Class?> upcomingEvent;

  late Future<String?> timeLeftForEvent;
  late Future<double?> percentagePassedForEvent;

  final eventService = EventService('');

  // Initialize selected menu item
  String _selectedMenuItem = "Összes";

  Timer? _refreshTimer; // Declare a Timer

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add the observer
    _loadExams();
    _loadAssignments();

    currentEvent = eventService.getCurrentEvent();
    upcomingEvent = eventService.getUpcomingEvent();

    timeLeftForEvent = eventService.timeLeftForCurrentEvent();
    percentagePassedForEvent = eventService.percentagePassedOfCurrentEvent();

    // Calculate seconds until the next minute
    _startRefreshTimer();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this); // Remove the observer
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startRefreshTimer();
    } else if (state == AppLifecycleState.paused) {
      _refreshTimer?.cancel();
    }
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel(); // Cancel any existing timer

    final now = DateTime.now();
    final secondsUntilNextMinute = 60 - now.second;

    // Wait until the next minute and then start periodic refresh
    Future.delayed(Duration(seconds: secondsUntilNextMinute), () {
      _handleRefresh();
      // Set up the timer to refresh every minute
      _refreshTimer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
        _handleRefresh();
      });
    });
  }

  Future<void> _handleRefresh() async {
    // bool? hasVibrator = await Vibration.hasVibrator();
    // if (hasVibrator == true) {
    //   HapticFeedback.heavyImpact();
    // }

    try {
      await _loadExams();
      await _loadAssignments();

      setState(() {
        currentEvent = eventService.getCurrentEvent();
        upcomingEvent = eventService.getUpcomingEvent();

        timeLeftForEvent = eventService.timeLeftForCurrentEvent();
        percentagePassedForEvent = eventService.percentagePassedOfCurrentEvent();
      });
    } catch (e) {
      // Handle any errors during refresh
      print('Error during refresh: $e');
    }
  }

  Future<void> _loadExams() async {
    try {
      final exams = await DatabaseHelper.instance.getExams();
      setState(() {
        _exams = exams;
      });
    } catch (e) {
      print('Error loading exams: $e');
    }
  }

  Future<void> _loadAssignments() async {
    try {
      final assignments = await DatabaseHelper.instance.getAssignments();
      setState(() {
        _assignments = assignments;
      });
    } catch (e) {
      print('Error loading assignments: $e');
    }
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

  void _onMenuItemSelected(String item) {
    setState(() {
      _selectedMenuItem = item;
    });
  }

  Map<String, List<Widget>> _groupEventsByDate(List<Exam> exams, List<Assignment> assignments) {
    CurrentTime time = CurrentTime();
    final Map<String, List<Widget>> groupedEvents = {};
    final now = time.get_time();

    for (final exam in exams) {
      if (exam.startTime.isAfter(now) || exam.startTime.isAtSameMomentAs(now)) {
        final String date = DateFormat('yyyy MMM d').format(exam.startTime);
        if (groupedEvents.containsKey(date)) {
          groupedEvents[date]!.add(UpcomingContainer(
            homeContext: context,
            title: Exam.formatText(30, exam.title),
            date: date,
            isExam: true,
            onDelete: () => _deleteExam(exam),
            onEdit: () => _editExam(exam),
          ));
        } else {
          groupedEvents[date] = [
            UpcomingContainer(
              homeContext: context,
              title: Exam.formatText(40, exam.title),
              date: date,
              isExam: true,
              onDelete: () => _deleteExam(exam),
              onEdit: () => _editExam(exam),
            )
          ];
        }
      }
    }

    for (final assignment in assignments) {
      if (assignment.dueDate.isAfter(now) || assignment.dueDate.isAtSameMomentAs(now)) {
        final String date = DateFormat('yyyy MMM d').format(assignment.dueDate);
        if (groupedEvents.containsKey(date)) {
          groupedEvents[date]!.add(UpcomingContainer(
            homeContext: context,
            title: assignment.title,
            date: date,
            isExam: false,
            onDelete: () => _deleteAssignment(assignment),
            onEdit: () => _editAssignment(assignment),
          ));
        } else {
          groupedEvents[date] = [
            UpcomingContainer(
              homeContext: context,
              title: assignment.title,
              date: date,
              isExam: false,
              onDelete: () => _deleteAssignment(assignment),
              onEdit: () => _editAssignment(assignment),
            )
          ];
        }
      }
    }

    return groupedEvents;
  }

  void _deleteExam(Exam exam) {
    try {
      setState(() {
        _exams.remove(exam);
      });
      DatabaseHelper.instance.deleteExam(exam.id!);
    } catch (e) {
      print('Error deleting exam: $e');
    }
  }

  void _editExam(Exam exam) {
    // Implement edit functionality here
  }

  void _deleteAssignment(Assignment assignment) {
    try {
      setState(() {
        _assignments.remove(assignment);
      });
      DatabaseHelper.instance.deleteAssignment(assignment.id!);
    } catch (e) {
      print('Error deleting assignment: $e');
    }
  }

  void _editAssignment(Assignment assignment) {
    // Implement edit functionality here
  }

  // Filter events based on the selected menu item
  List<Widget> _buildUpcomingEvents() {
    List<Exam> filteredExams;
    List<Assignment> filteredAssignments;

    if (_selectedMenuItem == "Összes") {
      filteredExams = _exams;
      filteredAssignments = _assignments;
    } else if (_selectedMenuItem == "Zh-k") {
      filteredExams = _exams;
      filteredAssignments = [];
    } else if (_selectedMenuItem == "Beadandók") {
      filteredExams = [];
      filteredAssignments = _assignments;
    } else {
      filteredExams = [];
      filteredAssignments = [];
    }

    final groupedEvents = _groupEventsByDate(filteredExams, filteredAssignments);
    CurrentTime time = CurrentTime();
    // Sort the entries by date
    final sortedEntries = groupedEvents.entries.toList()
      ..sort((a, b) => DateFormat('yyyy MMM d').parse(a.key).compareTo(DateFormat('yyyy MMM d').parse(b.key)));
    // remove events from sorted entries that are in the past
    sortedEntries.removeWhere((entry) {
      final date = DateFormat('yyyy MMM d').parse(entry.key);
      return date.isBefore(time.get_time());
    });

    return sortedEntries.map((entry) {
      final String date = entry.key;
      final List<Widget> events = entry.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 15),
            child: Text(
              date,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...events,
        ],
      );
    }).toList();
  }

  // ---------------------Home Page Builder--------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 18, 32),
      // ---------------------Header--------------------------
      endDrawer: const DrawerMenu(), //Profile_menu pop up

      body: CustomMaterialIndicator(
        onRefresh: _handleRefresh,
        indicatorBuilder: (context, controller) {
          return RefreshIcon();
        },

        // ---------------------Body--------------------------
        child: CustomScrollView(
          slivers: <Widget>[
            DefaultAppBar(
              title: welcomeGenerator(),
              showBackButton: false,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // --------------------------- Classes and events ---------------------------
                  CalendarWidget(
                    currentEvent: currentEvent,
                    upcomingEvent: upcomingEvent,
                    timeLeftForEvent: timeLeftForEvent,
                    percentagePassedForEvent: percentagePassedForEvent,
                    homeContext: context,
                  ),

                  const SizedBox(height: 10),
                  // --------------------------- Horizontal menu ---------------------------
                  HorizontalScrollableMenu(
                    menuItems: ["Összes", "Zh-k", "Beadandók", "Vizsga időszak", "Szünetek"],
                    onItemSelected: _onMenuItemSelected,
                    selectedItem: _selectedMenuItem,
                  ),

                  // --------------------------- Add the title below the menu ---------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Közelgő események',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Container(
                          width: double.infinity,
                          height: 1.0,
                          color: Color.fromARGB(36, 255, 255, 255),
                        ),
                      ],
                    ),
                  ),

                  // --------------------------- Upcoming events ---------------------------
                  ..._buildUpcomingEvents(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          return CustomBottomNavigationBar(
            button1: () async {
              // Handle navigation to Home
            },
            button2: () {
              addAssignmentOrExam(context);
              _handleRefresh();
            },
            button3: () {
              // Open drawer menu
              Scaffold.of(context).openEndDrawer();
            },
          );
        },
      ),
    );
  }
}
