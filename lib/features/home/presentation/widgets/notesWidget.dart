import 'package:flutter/material.dart';
import 'package:univerx/features/notes/data/model/noteModel.dart';

class NotesWidget extends StatelessWidget {
  final List<Note> notes;
  final List<Note> favoriteNotes; // New parameter to accept favorite notes
  final BuildContext homeContext;

  NotesWidget({required this.notes, required this.homeContext, this.favoriteNotes = const [],});

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
                    const SizedBox(
                        height:
                            10), // Space between the title and the note list
                    // Display the list of notes
                    Expanded(
                      child: ListView.builder(
                        itemCount: favoriteNotes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 120, 120, 120),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    favoriteNotes[index].title,
                                    style: const TextStyle(
                                       // Highlighted color
                                      fontSize: 15,
                                      fontFamily: "sfpro",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    favoriteNotes[index].content,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontFamily: "sfpro",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
