import 'package:flutter/material.dart';

import 'package:univerx/features/notes/data/model/noteModel.dart';

class NotesWidget extends StatelessWidget {
  final List<Note> notes;
  final BuildContext homeContext;

  NotesWidget({required this.notes, required this.homeContext});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 5),
        Expanded(
          flex: 2,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(homeContext, "/notes"),
              child: Container(
                padding: EdgeInsets.all(15),
                height: 600,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Color.fromARGB(255, 20, 21, 27),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Notes",
                      style: TextStyle(
                        color: Color.fromARGB(255, 163, 172, 222),
                        fontSize: 23.0,
                        fontFamily: "sfpro",
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Display the list of notes
                    ...notes.map((note) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                note.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(width: 5),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 120, 120, 120),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                note.content,
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      );
                    }).toList(),
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