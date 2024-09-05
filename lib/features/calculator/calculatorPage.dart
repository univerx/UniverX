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

  // Variables to store the results
  double kki = 0;
  double ki = 0;
  int allCredits = 0;
  int completedCredits = 0;
  double average = 0;

  @override
  void initState() {
    super.initState();
    _classesFuture = _getClasses();
  }

  Future<List<Class>> _getClasses() async {
    return await DatabaseHelper.instance.getUniqueClasses();
  }

  void _calculate() {
    double summaTeljesitetKreditXerdemjegy = 0;
    completedCredits = 0;
    allCredits = 0;

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
    ki = summaTeljesitetKreditXerdemjegy / 30;
    kki = (ki * (completedCredits / allCredits)).toDouble();
    average = sa;

    // Trigger UI update
    setState(() {});
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
                  const SizedBox(height: 30),
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
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No classes found.'));
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
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ElevatedButton(
                                onPressed: _calculate,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 38, 51, 70),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                child: const Center(child: Text('Calculate', style: TextStyle(color: Colors.white, fontSize: 25))),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Results display
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'Eredmények',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // First Row with KKI and KI
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Box3DWidget(
                                  title: 'KKI',
                                  value: kki.toStringAsFixed(2),
                                  width: 130,
                                  height: 130,
                                ),
                                const SizedBox(width: 50), // Space between KKI and KI
                                Box3DWidget(
                                  title: 'KI',
                                  value: ki.toStringAsFixed(2),
                                  width: 130,
                                  height: 130,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Merged Row with Felvett and Teljesített
                            Box3DMergedWidget(
                              title1: 'Felvett',
                              value1: '$allCredits kr',
                              title2: 'Teljesített',
                              value2: '$completedCredits kr',
                              width: 310,
                              height: 130,
                            ),
                            const SizedBox(height: 20),
                            // Third Row with Átlag
                            Box3DWidget(
                              title: 'Átlag',
                              value: average.toStringAsFixed(2),
                              width: 130,
                              height: 130,
                            ),
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

// Custom widget to represent the 3D boxes
class Box3DWidget extends StatelessWidget {
  final String title;
  final String value;
  final double width;
  final double height;

  const Box3DWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 38, 51, 70),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(4, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget to represent the merged 3D box
class Box3DMergedWidget extends StatelessWidget {
  final String title1;
  final String value1;
  final String title2;
  final String value2;
  final double width;
  final double height;

  const Box3DMergedWidget({
    Key? key,
    required this.title1,
    required this.value1,
    required this.title2,
    required this.value2,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 38, 51, 70),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title1,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title2,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value2,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
