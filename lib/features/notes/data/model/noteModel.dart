import 'package:flutter/material.dart';

class Note {
 final int? id;
  final String title;
  final String content;
  final String createdAt;
  bool isFavorite; // Added isFavorite field

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isFavorite = false, // Add this to the constructor with a default value

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'isFavorite': isFavorite ? 1 : 0, // Add this to the map
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: map['createdAt'] ?? DateTime.now().toString(),
      isFavorite: map['isFavorite'] == 1, // Add this to the factory
    );
  }

  @override
  String toString() {
     return 'Note{id: $id, title: $title, content: $content, createdAt: $createdAt, isFavorite: $isFavorite}';
  }
}
