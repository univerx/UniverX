import 'package:flutter/material.dart';
import 'package:univerx/services/neptun_ICS_fetching.dart';
import 'package:univerx/features/common/widgets/box_3d.dart';
import 'package:univerx/models/class.dart';

class CalendarWidget extends StatelessWidget {
  final Future<Class?> currentEvent;
  final Future<Class?> upcomingEvent;
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
                          FutureBuilder<Class?>(
                            future: currentEvent,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (snapshot.hasData) {
                                final event = snapshot.data;
                                if (event != null) {
                                  return Text(
                                    Class.getFormattedTitle(event.title),
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
                            child: FutureBuilder<Class?>(
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
                          FutureBuilder<Class?>(
                            future: upcomingEvent,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (snapshot.hasData) {
                                final event = snapshot.data;
                                if (event != null) {
                                  return Text(
                                    '→ ${Class.getFormattedTitle(event.title)}',
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
                            child: FutureBuilder<Class?>(
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
                          } else if (snapshot.hasData && snapshot.data != null && snapshot.data! > 0) {
                            var percentagePassed = snapshot.data!;
                            return SizedBox(
                              height: 10,
                              child: LinearProgressIndicator(
                                backgroundColor: const Color.fromARGB(255, 20, 18, 32),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 255, 255)),
                                borderRadius: BorderRadius.circular(20),
                                value: percentagePassed,
                              ),
                            );
                          } else {
                            return Container(); // Return an empty container if there's no current event
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
