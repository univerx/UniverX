import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:univerx/models/noteModel.dart';
import 'package:univerx/pages/assignments.dart';
import 'package:univerx/pages/home.dart';
import 'package:univerx/pages/notes.dart';
import 'package:univerx/pages/zh.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

void main() async {
  //Initialize FFI
  sqfliteFfiInit();
  //Set the database factory
  databaseFactory = databaseFactoryFfi;
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        '/home': (context) => Home(),
        '/zh': (context) => Zh(),
        '/assignments': (context) => Assignments(),
        '/notes': (context) => Notes(),
      },
    );
  }
}
