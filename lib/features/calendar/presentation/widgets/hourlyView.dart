import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:univerx/features/calendar/data/model/calendarModel.dart'; // Adjust this import based on your project structure

class HourlyView extends StatelessWidget {
  final List<EventModel> events;
  final DateTime initialDate;

  HourlyView({required this.events, required this.initialDate});

  @override
  Widget build(BuildContext context) {
    EventController eventController = EventController();

    // Map EventModel to CalendarEventData and add to controller
    events.forEach((event) {
      eventController.add(
        CalendarEventData(
          date: event.start,
          startTime: event.start,
          endTime: event.end, // Ensure the end time is correctly set
          title: event.summary,
        ),
      );
    });

    print("Initial Date: $initialDate");
    if (eventController.allEvents.isEmpty) {
      print("No events");
    }else{
      print("Number of Events: ${eventController.allEvents.first.startTime}");
    }

    return ScrollConfiguration(
      behavior: NoScrollBehavior(),
      child: Container(
        color: Colors.black, // Set the background color to black
        child: DayView(
          controller: eventController,
          eventTileBuilder: (date, events, boundary, start, end) {
            // Build the event tile
            return Positioned(
              left: boundary.left,
              top: boundary.top,
              right: boundary.right,
              bottom: boundary.bottom,
              child: Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    events.first.title, // Display the title of the event
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
          dayTitleBuilder: (date) {
            return Container(
              color: Colors.black,
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text(
                  DateFormat('EEEE, MMM d').format(date),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
          backgroundColor: Colors.black,
          showVerticalLine: true,
          showLiveTimeLineInAllDays: true,
          minDay: DateTime(1990),
          maxDay: DateTime(2050),
          initialDay: initialDate,
          heightPerMinute: 0.7,
          eventArranger: SideEventArranger(),
          startHour: 5, // Adjust the start hour as needed
          endHour: 20,  // Adjust the end hour as needed
          //dayTitleBuilder: DayHeader.hidden, // Hide day header
          
          keepScrollOffset: true,
          timeLineBuilder: (date) {
            return Container(
              color: Colors.black,
              child: Center(
                child: Text(
                  DateFormat('HH:mm').format(date),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NoScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return NeverScrollableScrollPhysics();
  }
}
