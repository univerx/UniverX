// ---------------------Flutter Packages--------------------------
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io'; // Needed to detect platform


// ---------------------Self Defined Packages--------------------------
import 'package:univerx/features/home/homePage.dart';
import 'package:univerx/features/calendar/calendarPage.dart';
import 'package:univerx/features/exams/examsPage.dart';
import 'package:univerx/features/appointment/OLD_appointmentPage.dart';
import 'package:univerx/features/neptun_login/login.dart';
import 'package:univerx/services/neptun_API_fetching.dart';

import 'package:univerx/database/database_helper.dart';
import 'package:univerx/services/neptun_ICS_fetching.dart';

// ---------------------Other Packages--------------------------
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// --------------------- Pop Observer--------------------------
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ---------------------Initialize SQLite--------------------------

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // FFI initialization for desktop platforms
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Ensure the database is properly initialized
  await DatabaseHelper.instance.database;

  // ---------------------Fetch and Update Events--------------------------
  
  final result = await DatabaseHelper.instance.getCalendarICS();

  if (result != null) { // If there is value in the database
    String icsFilePath = result.toString();
    EventService eventService = EventService(icsFilePath);
    await eventService.fetchAndUpdateIcs();
  }
  
  /*
  // ---------------------Fetch and Update Api--------------------------
  final result = await DatabaseHelper.instance.getNeptunLogin();

  if (result != null) { // If there is value in the database
    await fetchAndUpdateApi();
  }
  */
  // ---------------------Run the App--------------------------
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkLoginStatus() async {
    final result = await DatabaseHelper.instance.getCalendarICS();
    return result != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
      ),


      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            return const Home();
          } else {
            return LoginPage();
          }
        },
      ),
      navigatorObservers: [routeObserver], // Set the observer
      // ---------------------Routes--------------------------
      routes: {
        '/home': (context) => const Home(),
        '/zh': (context) => const Zh(),
        '/assignments': (context) => const Appointment(),
        '/events': (context) => const Calendar(),
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
