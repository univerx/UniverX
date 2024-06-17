import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';
import 'package:univerx/database/database_helper.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:univerx/features/home/presentation/pages/homePage.dart';
import 'package:univerx/features/neptun_login/data/neptunApi.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController neptunController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  List<dynamic> universities = [];
  String? selectedUniversity;
  String? selectedUniversityUrl;

  @override
  void initState() {
    super.initState();
    _loadUniversities();
  }



  Future<void> _loadUniversities() async {
    String data = await rootBundle.loadString('lib/features/neptun_login/data/Institutes.json');
    setState(() {
      universities = json.decode(data);
    });
  }

  void _showWrongPasswordPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Wrong details!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Color.fromARGB(167, 84, 76, 128).withOpacity(0.2),
              Color.fromARGB(156, 12, 6, 36),
            ],
            stops: [0.3, 0.6, 1.0],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color.fromARGB(167, 82, 74, 125).withOpacity(0.2),
                Color.fromARGB(156, 12, 6, 36),
              ],
              stops: [0.3, 0.6, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3.0,
                    ),
                  ),
                  const SizedBox(height: 24.0), // Space between the title and the first input field
                  DropdownButton<String>(
                    value: selectedUniversity,
                    dropdownColor: Colors.grey[800],
                    hint: Text(
                      'Select University',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    isExpanded: true,
                    items: universities.map<DropdownMenuItem<String>>((university) {
                      return DropdownMenuItem<String>(
                        value: university['Name'],
                        child: Text(
                          university['Name'],
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedUniversity = value;
                        selectedUniversityUrl = universities.firstWhere(
                          (uni) => uni['Name'] == value,
                          orElse: () => {'Url': null}
                        )['Url'];
                      });
                    },
                  ),
                  const SizedBox(height: 24.0),
                  TextField(
                    controller: neptunController,
                    decoration: InputDecoration(
                      hintText: 'neptun code',
                      hintStyle: const TextStyle(
                        color: Colors.grey, // Placeholder text color
                        fontSize: 16.0, // Placeholder text size
                        letterSpacing: 1.5,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'password',
                      hintStyle: const TextStyle(
                        color: Colors.grey, // Placeholder text color
                        fontSize: 16.0, // Placeholder text size
                        letterSpacing: 1.5,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 48.0),
                  SizedBox(
                    width: double.infinity, // To make the button full width
                    child: ElevatedButton(
                      onPressed: () async {
                        final neptunCode = neptunController.text;
                        final password = passwordController.text;

                        if (selectedUniversityUrl != null && neptunCode.isNotEmpty && password.isNotEmpty) {
                          if(await checkLoginDetails(selectedUniversityUrl!, neptunCode, password) == true){
                            await DatabaseHelper.instance.saveNeptunLogin(
                              selectedUniversity!,
                              selectedUniversityUrl!,
                              neptunCode,
                              password,
                            );
                            //exit this page and load homepage
                            // Navigate to the home page
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const Home()), // Ensure Home is correctly imported
                            );

                          }
                          else {
                            print('Wrong details');
                            _showWrongPasswordPopup();
                          }
                        } else {
                          print('Missing details');
                          _showWrongPasswordPopup();

                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
