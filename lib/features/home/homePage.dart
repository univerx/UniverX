import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class _HomeState extends State<Home> with RouteAware {
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

  @override
  void initState() {
    super.initState();
    _loadExams();
    _loadAssignments();

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

    _loadExams();
    _loadAssignments();

    currentEvent = eventService.getCurrentEvent();
    upcomingEvent = eventService.getUpcomingEvent();

    timeLeftForEvent = eventService.timeLeftForCurrentEvent();
    percentagePassedForEvent = eventService.percentagePassedOfCurrentEvent();

    return await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  void _onMenuItemSelected(String item) {
    setState(() {
      _selectedMenuItem = item;
    });
  }

  Map<String, List<Widget>> _groupEventsByDate(List<Exam> exams, List<Assignment> assignments) {
    final Map<String, List<Widget>> groupedEvents = {};
    final now = DateTime(2024, 4, 30, 11, 30);

    for (final exam in exams) {
      if (exam.startTime.isAfter(now) || exam.startTime.isAtSameMomentAs(now)) {
        final String date = DateFormat('yyyy MMM d').format(exam.startTime);
        if (groupedEvents.containsKey(date)) {
          groupedEvents[date]!.add(UpcomingContainer(
            homeContext: context,
            title: Exam.getFormattedTitle(exam.title),
            date: date,
            isExam: true, // Pass true if it's an exam
          ));
        } else {
          groupedEvents[date] = [
            UpcomingContainer(
              homeContext: context,
              title: Exam.getFormattedTitle(exam.title),
              date: date,
              isExam: true, // Pass true if it's an exam
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
            isExam: false, // Pass false if it's an assignment
          ));
        } else {
          groupedEvents[date] = [
            UpcomingContainer(
              homeContext: context,
              title: assignment.title,
              date: date,
              isExam: false, // Pass false if it's an assignment
            )
          ];
        }
      }
    }

    return groupedEvents;
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

    // Sort the entries by date
    final sortedEntries = groupedEvents.entries.toList()
      ..sort((a, b) => DateFormat('yyyy MMM d').parse(a.key).compareTo(DateFormat('yyyy MMM d').parse(b.key)));
    // remove events from sorted entries that are in the past
    sortedEntries.removeWhere((entry) {
      final date = DateFormat('yyyy MMM d').parse(entry.key);
      return date.isBefore(DateTime.now());
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
              title: "UniX-PTE-TTK",
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
                    menuItems: ["Összes", "Zh-k", "Beadandók"],
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
              print('Navigating to Home');
            },
            button2: () {
              addAssignmentOrExam(context);
              _handleRefresh();
            },
            button3: () {
              // Open drawer menu
              Scaffold.of(context).openEndDrawer();
              print('Navigating to Menu');
            },
          );
        },
      ),
    );
  }
}
