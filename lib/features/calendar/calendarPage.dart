import 'package:flutter/material.dart';
import 'package:univerx/database/database_helper.dart';
import 'package:univerx/models/class.dart';


import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:calendar_view/calendar_view.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/services/icsLinkManager.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';
import 'package:univerx/features/calendar/widgets/customCalendar.dart';
import 'package:univerx/features/calendar/widgets/hourlyView.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<Calendar> {
  late final ValueNotifier<List<Class>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Class> _allEvents = [];
  DateTime initialDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    
    // Load events
    _loadEvents();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    _allEvents = await DatabaseHelper.instance.getClasses();

    setState(() {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    });
  }

  List<Class> _changeDateForInitialBUG(List<Class> events) {
  List<Class> newEvents = [];
  DateTime now = DateTime.now();
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
    setState(() {
      _focusedDay = DateTime.now();
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
            title: "UniX-Exams",
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

                        initialDate = __selectedEvents.isNotEmpty ? __selectedEvents.first.startTime : DateTime.now();
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
                      child: HourlyView(events: value, initialDate: initialDate),
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
