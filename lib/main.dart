import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:univerx/models/noteModel.dart';
import 'package:univerx/pages/assignments.dart';
import 'package:univerx/pages/home.dart';
import 'package:univerx/pages/notes.dart';
import 'package:univerx/pages/zh.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:univerx/events/fetchAndUpdateEvents.dart';
import 'package:univerx/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database; //
  //Initialize FFI
  sqfliteFfiInit();
  //Set the database factory
  databaseFactory = databaseFactoryFfi;

  String icsFilePath = 'https://neptun-web2.tr.pte.hu/hallgato/cal/cal.ashx?id=BB24FE2D35D43417A71C81D956920C8F1EEF975C7C8D75F121B7BAD54821D0977171BBD64EDB3A10.ics';
  await fetchAndUpdateEventsFromIcs(icsFilePath);
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
