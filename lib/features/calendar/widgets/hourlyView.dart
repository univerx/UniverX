import 'dart:math';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:univerx/models/class.dart';
import 'package:univerx/services/neptun_ICS_fetching.dart';

class HourlyView extends StatelessWidget {
  final List<Class> allEvents;
  final DateTime initialDate;

  HourlyView({required this.allEvents, required this.initialDate});

  @override
  Widget build(BuildContext context) {
    EventController eventController = EventController();

    // Map EventModel to CalendarEventData and add to controller
    allEvents.forEach((event) {
      eventController.add(
        CalendarEventData(
          date: event.startTime,
          startTime: event.startTime,
          endTime: event.endTime,
          title: event.title,
          description: event.location,
        ),
      );
    });

    int calculatedStartHour = (allEvents.isNotEmpty && allEvents.first.startTime.hour - 1 > 0)
        ? allEvents.first.startTime.hour - 1
        : 0;

    int calculatedEndHour = (allEvents.isNotEmpty && allEvents.last.endTime.hour + 1 < 24)
        ? allEvents.last.endTime.hour + 1
        : 24;

    double heightPerMinute = 0.8;
    for (Class event in allEvents) {
      if (event.endTime.difference(event.startTime).inMinutes < 90) {
        heightPerMinute = 1.5;
      }
    }
    for (Class event in allEvents) {
      if (event.endTime.difference(event.startTime).inMinutes < 60) {
        heightPerMinute = 2.1;
      }
    }

    bool doEventsCollide(Class event1, DateTime start, DateTime end) {
      return (event1.startTime.isBefore(end) &&
          start.isBefore(event1.endTime)) || event1.startTime == start || event1.endTime == end  || (start.isBefore(event1.endTime) &&
          event1.startTime.isBefore(end));
    }

    return ScrollConfiguration(
      behavior: NoScrollBehavior(),
      child: Container(
        child: DayView(
          controller: eventController,
          eventTileBuilder: (date, events, boundary, start, end) {
            if (events.isEmpty) {
              return Container();
            }

            // Check for overlapping events
            print(events);
            bool isOverlapping = false;
            for (int i = 0; i < allEvents.length; i++) {
              if (events[0].title != allEvents[i].title) {
                if (doEventsCollide(allEvents[i], events[0].startTime!, events[0].endTime!)) {
                  isOverlapping = true;
                  break;
                }
              }
            }

            return Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 36, 63, 109).withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 152, 152, 152).withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: const Border(
                  left: BorderSide(
                    color: Color.fromARGB(255, 84, 111, 178),
                    width: 4,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        DateFormat("HH:mm").format(events.first.startTime!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 84, 111, 178),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${events.first.description?.split(" ").first}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Class.getFormattedTitle(EventService.formatText(isOverlapping ? 16 : 35, events.first.title)),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16 , // Adjust font size if overlapping
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
          backgroundColor: const Color.fromARGB(255, 20, 18, 32),
          showVerticalLine: true,
          showLiveTimeLineInAllDays: true,
          minDay: DateTime(1990),
          maxDay: DateTime(2050),
          initialDay: initialDate,
          heightPerMinute: heightPerMinute,
          eventArranger: SideEventArranger(),
          startHour: calculatedStartHour,
          endHour: calculatedEndHour,
          dayTitleBuilder: DayHeader.hidden,
          keepScrollOffset: true,
          timeLineBuilder: (date) {
            return Container(
              child: Center(
                child: Text(
                  DateFormat('HH:mm').format(date),
                  style: const TextStyle(color: Color.fromARGB(255, 97, 97, 97)),
                ),
              ),
            );
          },
          hourIndicatorSettings: const HourIndicatorSettings(
            color: Color.fromARGB(255, 97, 97, 97),
            height: 0.7,
          ),
          liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
            color: Color.fromARGB(255, 84, 111, 178),
            height: 2.0,
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
