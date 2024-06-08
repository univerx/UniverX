import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:univerx/features/exams/data/model/examModel.dart';
import 'package:univerx/features/assignments/data/model/assignmentModel.dart';
import 'package:univerx/features/notes/data/model/noteModel.dart';
import 'package:univerx/features/calendar/data/model/calendarModel.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('database33.db');
    
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );  
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''      
      CREATE TABLE exams(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''      
      CREATE TABLE assignments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''      
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        isFavorite BOOLEAN NOT NULL

      )
    ''');

    await db.execute("""
      CREATE TABLE events(
        start TEXT, end TEXT,
        summary TEXT,
        location TEXT
      )
    """);

    await db.execute('''
      CREATE TABLE calendarICS(
        url TEXT NOT NULL
      )
    ''');

  }

  // ----------------------- Exam methods ------------------------
  Future<void> insertExam(ExamModel exam) async {
    final db = await instance.database;
    await db.insert(
      'exams',
      exam.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ExamModel>> getExams() async {
    final db = await instance.database;
    final result = await db.query(
      'exams',
      orderBy: 'date ASC', // Sort by date in ascending order
    );
    
    return result.map((json) => ExamModel.fromMap(json)).toList();
  }

  Future<void> updateExam(ExamModel exam) async {
    final db = await instance.database;
    await db.update(
      'exams',
      exam.toMap(),
      where: 'id = ?',
      whereArgs: [exam.id],
    );
  }

  Future<void> deleteExam(int id) async {
    final db = await instance.database;
    await db.delete(
      'exams',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  // ----------------------- Assignment methods ------------------------
  Future<void> insertAssignment(AssignmentModel assignment) async {
    final db = await instance.database;
    await db.insert(
      'assignments',
      assignment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AssignmentModel>> getAssignments() async {
    final db = await instance.database;
    final result = await db.query(
      'assignments',
      orderBy: 'date ASC', // Sort by date in ascending order
    );
    return result.map((json) => AssignmentModel.fromMap(json)).toList();
  }

  Future<void> updateAssignment(AssignmentModel assignment) async {
    final db = await instance.database;
    await db.update(
      'assignments',
      assignment.toMap(),
      where: 'id = ?',
      whereArgs: [assignment.id],
    );
  }

  Future<void> deleteAssignment(int id) async {
    final db = await instance.database;
    await db.delete(
      'assignments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ----------------------- notes methods ------------------------
  Future<void> insertNote(Note note) async {
    final db = await instance.database;
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

 Future<List<Note>> getNotes() async {
    final db = await instance.database;
    final result = await db.query('notes');
    return result.map((json) => Note.fromMap(json)).toList();
  }
  Future<void> updateNote(Note note) async {
    final db = await instance.database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await instance.database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
Future<List<Note>> getFavoriteNotes() async {
  final db = await instance.database;
  final result = await db.query(
    'notes',
    orderBy: 'isFavorite DESC', // Sorting by isFavorite, descending
  );
  return result.map((json) => Note.fromMap(json)).toList();
}

  // ----------------------- events methods ------------------------
  Future<int> saveEvent(EventModel event) async {
    var dbClient = await instance.database;
    int res = await dbClient.insert("events", event.toMap());
    return res;
  }

  Future<List<EventModel>> getAllEvents() async {
    var dbClient = await instance.database;
    var result = await dbClient.rawQuery('SELECT * FROM events');
    List<EventModel> events = result.map((e) => EventModel.fromMap(e)).toList();
    return events;
  }

  Future<int> updateEvent(EventModel event) async {
    var dbClient = await instance.database;
    return await dbClient.update("events", event.toMap(),
        where: "start = ? AND end = ? AND summary = ?",
        whereArgs: [event.start.toIso8601String(), event.end.toIso8601String(), event.summary]);
  }

  Future<int> deleteEvent(EventModel event) async {
    var dbClient = await instance.database;
    return await dbClient.delete("events",
        where: "start = ? AND end = ? AND summary = ?",
        whereArgs: [event.start.toIso8601String(), event.end.toIso8601String(), event.summary]);
  }

  Future<void> clearAllEvents() async {
    var dbClient = await instance.database;
    await dbClient.delete("events");

  }

  // ----------------------- calendarICS methods ------------------------
  Future<int> saveCalendarICS(String url) async {
    var dbClient = await instance.database;
    return await dbClient.insert("calendarICS", {"url": url});
  }

  Future<Object?> getCalendarICS() async {
    var dbClient = await instance.database;
    var result = await dbClient.rawQuery('SELECT * FROM calendarICS');
    if (result.isEmpty) {
      return null;
    }
    return result[0]["url"];
  }

  Future<int> updateCalendarICS(String url) async {
    var dbClient = await instance.database;
    return await dbClient.update("calendarICS", {"url": url});
  }

  Future<int> deleteCalendarICS() async {
    var dbClient = await instance.database;
    return await dbClient.delete("calendarICS");
  }

}
