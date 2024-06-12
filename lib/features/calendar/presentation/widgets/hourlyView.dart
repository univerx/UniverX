import 'dart:math';

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

    int calculatedStartHour = (events.isNotEmpty && events.first.start.hour - 1 > 0)
        ? events.first.start.hour - 1
        : 0;

    int calculatedEndHour = (events.isNotEmpty && events.last.end.hour + 1 < 24)
        ? events.last.end.hour + 1
        : 24;


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
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.only(left: 8), // Adding padding on the left
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 36, 63, 109).withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 152, 152, 152).withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Positioning the shadow
                    ),
                  ],
                  border: const Border(
                    left: BorderSide(
                      color: Color.fromARGB(255, 84, 111, 178), // Change this to the color you want
                      width: 4, // Adjust the width of the border as needed
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8), // Add padding to the top for spacing
                      child: Text(
                        DateFormat("HH:mm").format(events.first.startTime!), // Placeholder for the location or time
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4), // Add some space between the two texts
                    Text(
                      events.first.title.substring(0, 15), // Display the title of the event
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
          startHour: calculatedStartHour, // Adjust the start hour as needed
          endHour: calculatedEndHour,  // Adjust the end hour as needed
          dayTitleBuilder: DayHeader.hidden, // Hide day header
          
          keepScrollOffset: true,
          timeLineBuilder: (date) {
            return Container(
              color: Colors.black,
              child: Center(
                child: Text(
                  DateFormat('HH:mm').format(date),
                  style: const TextStyle(color: Color.fromARGB(255, 97, 97, 97)),
                ),
              ),
            );
          },
          hourIndicatorSettings: const HourIndicatorSettings(
            color: Color.fromARGB(255, 97, 97, 97), // Set your desired color here
            height: 0.7, // Set your desired thickness here
          ),
          liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
            color: Color.fromARGB(255, 84, 111, 178), // Set your desired color here
            height: 2.0, // Set your desired thickness here
          ),
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
