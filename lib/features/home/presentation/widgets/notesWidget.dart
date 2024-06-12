import 'dart:math';

import 'package:flutter/material.dart';
import 'package:univerx/features/notes/data/model/noteModel.dart';
import 'package:univerx/features/home/presentation/widgets/noteCard.dart'; // Import the new NoteCard widget

class NotesWidget extends StatelessWidget {
  final BuildContext homeContext;
  final List<Note> notes;

  NotesWidget({
    required this.homeContext,
    this.notes = const [],
  });

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
                    const SizedBox(height: 10),
                    Expanded(
                      child: Column(
                        children: List.generate(min(notes.length, 3) , (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: NoteCard(note: notes[index]),
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}
