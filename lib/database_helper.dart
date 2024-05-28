import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:univerx/models/assignmentModel.dart';
import 'models/examModel.dart'; // Assume this model has toMap() and fromMap() methods
import 'models/assignmentModel.dart'; // Similarly assume this model has toMap() and fromMap() methods
import 'models/noteModel.dart'; // Similarly assume this model has toMap() and fromMap() methods

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('database5.db');
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
        content TEXT NOT NULL
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


}
