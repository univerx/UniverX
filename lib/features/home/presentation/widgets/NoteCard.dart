import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for formatting date
import 'package:univerx/features/notes/data/model/noteModel.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF6A8BC1), // Starting color (similar to the left side of the image)
              Color(0xFF030415)  // Ending color (similar to the right side of the image)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  fontFamily: "sfpro",
                  color: Colors.white, // Changed to white for better contrast with dark background
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                note.content,
                style: const TextStyle(
                  fontFamily: "sfpro",
                  color: Colors.white, // Changed to white for better contrast with dark background
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat.yMMMMd().format(DateTime.parse(note.createdAt)),
                  style: const TextStyle(
                    color: Colors.white, // Changed to white for better contrast with dark background
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
