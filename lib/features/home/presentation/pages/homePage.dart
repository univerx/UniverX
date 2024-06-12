// ---------------------Flutter Packages--------------------------
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------------------Self Defined Packages--------------------------
import 'package:univerx/features/exams/data/model/examModel.dart';
import 'package:univerx/features/assignments/data/model/assignmentModel.dart';
import 'package:univerx/features/notes/data/model/noteModel.dart';
import 'package:univerx/features/calendar/data/model/calendarModel.dart';

import 'package:univerx/database/database_helper.dart';
import 'package:univerx/event_service.dart';

import 'package:univerx/main.dart';

// ---------------------Other Packages--------------------------
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:vibration/vibration.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/common/widgets/refresh_app_icon.dart';
import 'package:univerx/features/home/presentation/widgets/calendarWidget.dart';
import 'package:univerx/features/home/presentation/widgets/examsAssignmentsWidget.dart';
import 'package:univerx/features/home/presentation/widgets/notesWidget.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

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

    _loadExams();
    _loadAssignments();
    _loadNotes();

    currentEvent = eventService.getCurrentEvent();
    upcomingEvent = eventService.getUpcomingEvent();

    timeLeftForEvent = eventService.timeLeftForCurrentEvent();
    percentagePassedForEvent = eventService.percentagePassedOfCurrentEvent();

    return await Future<void>.delayed(const Duration(seconds: 0, milliseconds: 500));
  }

  // ---------------------Home Page Builder--------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
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

                    const SizedBox(height: 10), // space between the calendar and the (upcoming exams and assignments)
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        // ---------------------------------- exams ---------------------------
                        ExamsAssignmentsWidget(
                          title: "Exams",
                          exams: _exams,
                          routeName: '/zh',
                          homeContext: context,
                        ),
                        const SizedBox(width: 10),
                        // ---------------------------------- assignments ---------------------------
                        ExamsAssignmentsWidget(
                          title: "Assignments",
                          assignments: _assignments,
                          routeName: '/assignments',
                          homeContext: context,
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ---------------------------------- notes ---------------------------
                    NotesWidget(
                      notes: _notes,
                      homeContext: context,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
