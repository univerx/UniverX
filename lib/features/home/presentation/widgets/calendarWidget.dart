import 'package:flutter/material.dart';
import 'package:univerx/features/calendar/data/model/calendarModel.dart';
import 'package:univerx/features/home/presentation/pages/homePage.dart';


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
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Color.fromARGB(255, 20, 21, 27),
                ),
                padding: EdgeInsets.all(15),
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
                                  '${event.summary.substring(0, 15)}',
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
                            color: Color.fromARGB(255, 35, 37, 48),
                            borderRadius: BorderRadius.circular(10),
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
                                      color: Color.fromARGB(255, 163, 172, 222),
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
                    SizedBox(height: 5),
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
                                  '→ ${event.summary.substring(0, 15)}',
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
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 35, 37, 48),
                            borderRadius: BorderRadius.circular(10),
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
                                      color: Color.fromARGB(255, 163, 172, 222),
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
                    const SizedBox(height: 12),
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
                              backgroundColor: Color.fromARGB(255, 43, 44, 49),
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
        SizedBox(width: 5),
      ],
    );
  }
}
