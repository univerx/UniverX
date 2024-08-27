import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

//------------------ Models ------------------
import 'package:univerx/models/instructor.dart';
import 'package:univerx/models/class.dart';
import 'package:univerx/models/exam.dart';
import 'package:univerx/models/assignment.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('test_12.db');
    
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Instructor (
        instructor_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        phone_number TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Class (
        class_id INTEGER,
        title TEXT,
        description TEXT,
        start_time TEXT,
        end_time TEXT,
        location TEXT,
        instructor_id INTEGER,
        is_user_created BOOLEAN DEFAULT FALSE,
        FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Exam (
        exam_id INTEGER,
        class_id INTEGER,
        title TEXT,
        description TEXT,
        date TEXT,
        start_time TEXT,
        end_time TEXT,
        location TEXT,
        is_user_created BOOLEAN DEFAULT FALSE,
        FOREIGN KEY (class_id) REFERENCES Class(class_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Assignment (
        assignment_id INTEGER PRIMARY KEY AUTOINCREMENT,
        class_id INTEGER,
        title TEXT,
        description TEXT,
        due_date TEXT,
        is_user_created BOOLEAN DEFAULT FALSE,
        FOREIGN KEY (class_id) REFERENCES Class(class_id)
      )
    ''');
    await db.execute('''
      CREATE TABLE calendarICS(
        url TEXT NOT NULL
      )
    ''');

     await db.execute('''
      CREATE TABLE NeptunLogin(
        university TEXT NOT NULL,
        url TEXT NOT NULL,
        login TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }


  // --------------------- Instructor CRUD operations --------------------------
  Future<int> insertInstructor(Instructor instructor) async {
    Database db = await database;
    return await db.insert('Instructor', instructor.toMap());
  }

  Future<List<Instructor>> getInstructors() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Instructor');
    return List.generate(maps.length, (i) {
      return Instructor.fromMap(maps[i]);
    });
  }

  Future<int> updateInstructor(Instructor instructor) async {
    Database db = await database;
    return await db.update(
      'Instructor',
      instructor.toMap(),
      where: 'instructor_id = ?',
      whereArgs: [instructor.id],
    );
  }

  Future<int> deleteInstructors() async {
    Database db = await database;
    return await db.delete('Instructor');
  }


  // --------------------- Class CRUD operations --------------------------
  Future<int> insertClass(Class classObj) async {
    Database db = await database;
    return await db.insert('Class', classObj.toMap());
  }

  Future<List<Class>> getClasses() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Class');
    return List.generate(maps.length, (i) {
      return Class.fromMap(maps[i]);
    });
  }

  Future<int> updateClass(Class classObj) async {
    Database db = await database;
    return await db.update(
      'Class',
      classObj.toMap(),
      where: 'class_id = ?',
      whereArgs: [classObj.id],
    );
  }

  Future<int> deleteClass(int id) async {
    Database db = await database;
    return await db.delete(
      'Class',
      where: 'class_id = ? AND is_user_created = 1', // Only delete user-created classes
      whereArgs: [id],
    );
  }

  Future<int> deleteNeptunClasses() async {
    Database db = await database;
    return await db.delete(
      'Class',
      where: 'is_user_created = 0', // Only delete non user-created exams
    );
  }
  

  // --------------------- Exam CRUD operations --------------------------
  Future<int> insertExam(Exam exam) async {
    Database db = await database;
    return await db.insert('Exam', exam.toMap());
  }

  Future<List<Exam>> getExams() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Exam');
    return List.generate(maps.length, (i) {
      return Exam.fromMap(maps[i]);
    });
  }

  Future<int> updateExam(Exam exam) async {
    Database db = await database;
    return await db.update(
      'Exam',
      exam.toMap(),
      where: 'exam_id = ?',
      whereArgs: [exam.id],
    );
  }

  Future<int> deleteExam(int id) async {
    Database db = await database;
    return await db.delete(
      'Exam',
      where: 'exam_id = ? AND is_user_created = 1', // Only delete user-created exams
      whereArgs: [id],
    );
  }

  Future<int> deleteNeptunExams() async {
    Database db = await database;
    return await db.delete(
      'Exam',
      where: 'is_user_created = 0', // Only delete non user-created exams
    );
  }

  // --------------------- Assignment CRUD operations --------------------------
  Future<int> insertAssignment(Assignment assignment) async {
    Database db = await database;
    return await db.insert('Assignment', assignment.toMap());
  }

  Future<List<Assignment>> getAssignments() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Assignment');
    return List.generate(maps.length, (i) {
      return Assignment.fromMap(maps[i]);
    });
  }

  Future<int> updateAssignment(Assignment assignment) async {
    Database db = await database;
    return await db.update(
      'Assignment',
      assignment.toMap(),
      where: 'assignment_id = ?',
      whereArgs: [assignment.id],
    );
  }

  Future<int> deleteAssignment(int id) async {
    Database db = await database;
    return await db.delete(
      'Assignment',
      where: 'assignment_id = ? AND is_user_created = 1', // Only delete user-created assignments
      whereArgs: [id],
    );
  }

  Future<int> deleteNeptunAssignments() async {
    Database db = await database;
    return await db.delete(
      'Assignment',
      where: 'is_user_created = 0', // Only delete non user-created exams
    );
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

  // ----------------------- NeptunLogin methods ------------------------
  Future<int> saveNeptunLogin(String university, String url,String login, String password) async {
    var dbClient = await instance.database;
    return await dbClient.insert("NeptunLogin", {"university": university, "url": url, "login": login, "password": password});
  }

  Future<Object?> getNeptunLogin() async {
    var dbClient = await instance.database;
    var result = await dbClient.rawQuery('SELECT * FROM NeptunLogin');
    if (result.isEmpty) {
      return null;
    }
    return {"university": result[0]["university"], "url": result[0]["url"], "login": result[0]["login"], "password": result[0]["password"]};
  }

  Future<int> updateNeptunLogin(String university, String url, String login, String password) async {
    var dbClient = await instance.database;
    return await dbClient.update("NeptunLogin", {"university": university, "url": url, "login": login, "password": password});
  }

  Future<int> deleteNeptunLogin() async {
    var dbClient = await instance.database;
    return await dbClient.delete("NeptunLogin");
  }
}
