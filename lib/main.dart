// ---------------------Flutter Packages--------------------------
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ---------------------Self Defined Packages--------------------------
import 'package:univerx/features/home/presentation/pages/homePage.dart';
import 'package:univerx/features/calendar/presentation/pages/calendarPage.dart';
import 'package:univerx/features/exams/presentation/pages/examsPage.dart';
import 'package:univerx/features/assignments/presentation/pages/assignmentsPage.dart';
import 'package:univerx/features/notes/presentation/pages/notesPage.dart';


import 'package:univerx/events/fetchAndUpdateEvents.dart';
import 'package:univerx/database_helper.dart';

// ---------------------Other Packages--------------------------
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// --------------------- Pop Observer--------------------------
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  // ---------------------Initialize SQLite--------------------------
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // ---------------------Fetch and Update Events--------------------------
  final result = await DatabaseHelper.instance.getCalendarICS();

  if (result != null) { // If there is value in the database
    if (result.toString() == ''){ // '' means it was removed by the user
      await DatabaseHelper.instance.clearAllEvents();
    } 
    else { // If there is a ICS link in the database
      String icsFilePath = result.toString();
      await fetchAndUpdateEventsFromIcs(icsFilePath);
    }
  }

  // ---------------------Run the App--------------------------
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
      home: const Home(),
      navigatorObservers: [routeObserver], // Set the observer
      // ---------------------Routes--------------------------
      routes: {
        '/home': (context) => const Home(),
        '/zh': (context) => const Zh(),
        '/assignments': (context) => const Assignments(),
        '/notes': (context) => const Notes(),
        '/events': (context) => const Events(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          return MaterialPageRoute(builder: (context) => const Home());
        }
        // Add other routes as necessary
        return null;
      },
    );
  }
}
