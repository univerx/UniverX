import 'package:flutter/material.dart';
import 'package:univerx/features/calculator/widgets/classBox.dart';
import 'package:univerx/models/class.dart';
import 'package:univerx/database/database_helper.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/common/widgets/box_3d.dart';
import 'package:univerx/models/exam.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  late Future<List<Class>> _classesFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future when the widget is created
    _classesFuture = _getClasses();
  }

  Future<List<Class>> _getClasses() async {
    return await DatabaseHelper.instance.getUniqueClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 18, 32),
      body: CustomScrollView(
        slivers: <Widget>[
          DefaultAppBar(
            title: 'Calculator',
            showBackButton: true,
            showProfileMenu: false,
            showDoneButton: false,
          ),
          SliverFillRemaining(
            child: SingleChildScrollView( // This makes the whole page scrollable
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tárgyaid',
                          style: TextStyle(
                            color: Color.fromARGB(255, 188, 188, 188),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Credit',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 45), // Spacing between Credit and Jegy
                            Text(
                              'Jegy',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 35),
                          ],
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<Class>>(
                    future: _classesFuture,
                    builder: (BuildContext context, AsyncSnapshot<List<Class>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No classes found.'));
                      } else {
                        List<Class> classes = snapshot.data!;
                        return Column( // Changed from ListView to Column to avoid nested scrolling
                          children: classes.map((clazz) {
                            return ClassItem(
                              title: Exam.formatText(16, clazz.title),
                              creditsController: TextEditingController(text: '1'), // Example initial value
                              gradeController: TextEditingController(text: '1'),   // Example initial value
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
