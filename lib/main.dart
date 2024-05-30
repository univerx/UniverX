import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:univerx/models/noteModel.dart';
import 'package:univerx/pages/assignments.dart';
import 'package:univerx/pages/events.dart';
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
  // ezt is tisztitani kell!!!!!!KJOIFJOIAFJOISFJOAIJFIOASJFOIAJSAOIJFIOASJfIOASJfio
  final result = await DatabaseHelper.instance.getCalendarICS();
  if (result != null){
    if (result.toString() == ''){
      print("asd");
      await DatabaseHelper.instance.clearAllEvents();
    }
    else{
      print(result.toString());
      String icsFilePath = result.toString();
      await fetchAndUpdateEventsFromIcs(icsFilePath);
    }
  }

  
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
        '/events': (context) => Events(),
      },
    );
  }
}
