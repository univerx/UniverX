import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:univerx/features/home/presentation/pages/homePage.dart';
import 'package:univerx/database/database_helper.dart';
import 'package:univerx/features/calendar/data/model/calendarModel.dart';
import 'package:univerx/event_service.dart'; // Assuming you have a model for assignments
import 'package:univerx/features/calendar/data/datasources/fetchAndUpdateEvents.dart'; // Assuming you have a model for assignments

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:calendar_view/calendar_view.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/calendar/presentation/widgets/icsLinkManager.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';
import 'package:univerx/features/calendar/presentation/widgets/customCalendar.dart';
import 'package:univerx/features/calendar/presentation/widgets/hourlyView.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<Calendar> {
  late final ValueNotifier<List<EventModel>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<EventModel> _allEvents = [];

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
    _allEvents = await DatabaseHelper.instance.getAllEvents();

    setState(() {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    });
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    return _allEvents.where((event) => isSameDay(event.start, day)).toList();
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
      body: CustomScrollView(
        slivers: <Widget>[
          DefaultAppBar(
            title: "UniX-Exams",
            showBackButton: true,
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
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _selectedEvents.value = _getEventsForDay(selectedDay);
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

                ValueListenableBuilder<List<EventModel>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    DateTime initialDate = value.isNotEmpty ? value.first.start : DateTime.now();
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
