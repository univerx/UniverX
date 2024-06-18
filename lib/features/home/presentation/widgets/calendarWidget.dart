import 'package:flutter/material.dart';
import 'package:univerx/features/calendar/data/model/calendarModel.dart';
import 'package:univerx/event_service.dart';
import 'package:univerx/features/common/widgets/box_3d.dart';

class CalendarWidget extends StatelessWidget {
  final Future<EventModel?> currentEvent;
  final Future<EventModel?> upcomingEvent;
  final Future<String?> timeLeftForEvent;
  final Future<double?> percentagePassedForEvent;
  final BuildContext homeContext;

  CalendarWidget({
    required this.currentEvent,
    required this.upcomingEvent,
    required this.timeLeftForEvent,
    required this.percentagePassedForEvent,
    required this.homeContext,
  });
  final eventService = EventService('');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Expanded(
          flex: 2,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(homeContext, '/events'),
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                height: 113,
                decoration: Box3D(),
                child: Container(
                  margin: EdgeInsets.all(1), // Adjust this value to change the border width
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 38, 51, 70),
                  ),
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0),
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
                                    EventModel.getFormattedTitle(event.summary),
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
                              color: const Color.fromARGB(255, 20, 18, 32),
                              borderRadius: BorderRadius.circular(8),
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
                                        color: Color.fromARGB(255, 255, 255, 255),
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
                      SizedBox(height: 10),
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
                                    '→ ${EventModel.getFormattedTitle(event.summary)}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      fontFamily: "sfpro",
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
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 20, 18, 32),
                              borderRadius: BorderRadius.circular(8),
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
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
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
                      //const SizedBox(height: 0),
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
                                backgroundColor: const Color.fromARGB(255, 20, 18, 32),
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
        ),
        SizedBox(width: 5),
      ],
    );
  }
}
