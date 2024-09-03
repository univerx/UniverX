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
  final List<TextEditingController> _creditsControllers = [];
  final List<TextEditingController> _gradeControllers = [];

  @override
  void initState() {
    super.initState();
    _classesFuture = _getClasses();
  }

  Future<List<Class>> _getClasses() async {
    return await DatabaseHelper.instance.getUniqueClasses();
  }

  void _calculate() {
    double totalCredits = 0;
    double weightedSum = 0;
    double summaTeljesitetKreditXerdemjegy = 0;
    int completedCredits = 0;
    int allCredits = 0;

    for (int i = 0; i < _creditsControllers.length; i++) {
      int credits = int.tryParse(_creditsControllers[i].text) ?? 0;
      int grade = int.tryParse(_gradeControllers[i].text) ?? 0;

      if (grade > 1) {
        summaTeljesitetKreditXerdemjegy += grade * credits;
        completedCredits += credits;
      }
      allCredits += credits;
    }

    double sa = completedCredits > 0 ? (summaTeljesitetKreditXerdemjegy / completedCredits) : 0;
    double ki = summaTeljesitetKreditXerdemjegy / 30;
    double kki = (ki * (completedCredits / allCredits)).toDouble();

    // Display results using a dialog or Snackbar
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Results'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("SA: ${sa.toStringAsFixed(2)}"),
            Text("KKI: ${kki.toStringAsFixed(2)}"),
            Text("KI: ${ki.toStringAsFixed(2)}"),
            Text("All Credits: $allCredits"),
            Text("Completed Credits: $completedCredits"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                            SizedBox(width: 45),
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
                        _creditsControllers.clear();
                        _gradeControllers.clear();
                        return Column(
                          children: [
                            ...classes.map((clazz) {
                              TextEditingController creditsController = TextEditingController(text: '1');
                              TextEditingController gradeController = TextEditingController(text: '1');
                              _creditsControllers.add(creditsController);
                              _gradeControllers.add(gradeController);
                              return ClassItem(
                                title: Exam.formatText(16, clazz.title),
                                creditsController: creditsController,
                                gradeController: gradeController,
                              );
                            }).toList(),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ElevatedButton(
                                onPressed: _calculate,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                child: Center(child: Text('Calculate')),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
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
