import 'package:flutter/material.dart';
import 'package:univerx/database/database_helper.dart';
import 'package:univerx/models/assignment.dart';
import 'package:univerx/models/class.dart';


import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:calendar_view/calendar_view.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/models/exam.dart';
import 'package:univerx/services/icsLinkManager.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';
import 'package:univerx/features/calendar/widgets/customCalendar.dart';
import 'package:univerx/features/calendar/widgets/hourlyView.dart';
import 'package:univerx/database/appdata.dart';


class Calendar extends StatefulWidget {
  final DateTime? focusedDay;

  const Calendar({
    Key? key,
    this.focusedDay,
  }) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<Calendar> {
  late final ValueNotifier<List<Class>> _selectedEvents;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  List<Class> _allEvents = [];
  late DateTime initialDate;

  @override
  void initState() {
    super.initState();

    // Load events
    _loadEvents();
    CurrentTime time = CurrentTime();
    _focusedDay = time.get_time();
    _selectedDay = _focusedDay;
    initialDate = time.get_time();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
  // Fetch classes, exams, and assignments concurrently
  final classesFuture = DatabaseHelper.instance.getClasses();
  final examsFuture = DatabaseHelper.instance.getExams();
  final assignmentsFuture = DatabaseHelper.instance.getAssignments();

  // Wait for all futures to complete
  final results = await Future.wait([classesFuture, examsFuture, assignmentsFuture]);

  // Extract the results
  final classes = results[0] as List<Class>;
  final exams = results[1] as List<Exam>;
  final assignments = results[2] as List<Assignment>;

  // Convert exams and assignments to classes and combine all events into _allEvents
  _allEvents = [
    ...classes,
    ...exams.map((exam) => exam.convertExamToClass()),
    ...assignments.map((assignment) => assignment.convertAssignmentToClass()),
  ];
  setState(() {
    _selectedEvents.value = _getEventsForDay(_selectedDay!);
  });
}


  List<Class> _changeDateForInitialBUG(List<Class> events) {
    CurrentTime time = CurrentTime();
    List<Class> newEvents = [];
    DateTime now = time.get_time();
    for (Class event in events) {
      DateTime newStart = DateTime(now.year, now.month, now.day, event.startTime.hour, event.startTime.minute);
      DateTime newEnd = DateTime(now.year, now.month, now.day, event.endTime.hour, event.endTime.minute);
      newEvents.add(Class(
        id:event.id,
        title: event.title,
        description: "",
        startTime: newStart,
        endTime: newEnd,
        location: event.location,
        instructorId: -1,
        //exam: event.exam,
        isUserCreated: false
      ));
    }
    return newEvents;
  }


  List<Class> _getEventsForDay(DateTime day) {
    return _allEvents.where((event) => isSameDay(event.startTime, day)).toList();
  }

  void _goToToday() {
    CurrentTime time = CurrentTime();
    setState(() {
      _focusedDay = time.get_time() ;
      _selectedDay = _focusedDay;
    });
    _selectedEvents.value = _getEventsForDay(_selectedDay!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 18, 32),

      body: CustomScrollView(
        slivers: <Widget>[
          DefaultAppBar(
            title: "UniX-Calendar",
            showBackButton: true,
            /*
            icsButton: CustomImportButton(
              loadEvents: _loadEvents,
            ),
            */
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // -----------------------CALENDAR-----------------------
                CustomCalendar(
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDay,
                  selectedEvents: _selectedEvents,
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      List<Class> __selectedEvents = _getEventsForDay(selectedDay);
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;

                        initialDate = __selectedEvents.isNotEmpty ? __selectedEvents.first.startTime : CurrentTime().get_time();
                        _selectedEvents.value = _changeDateForInitialBUG(__selectedEvents);
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: _getEventsForDay,
                ),
                
                const SizedBox(height: 8.0),

                // -----------------------SELECTED EVENTS-----------------------

                ValueListenableBuilder<List<Class>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return Container(
                      height: 1000,  // Adjust the height as needed
                      child: HourlyView(allEvents: value, initialDate: initialDate, isToday: isSameDay(_selectedDay!, CurrentTime().get_time())),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
