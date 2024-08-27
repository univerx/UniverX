import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';
import 'package:univerx/database/database_helper.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:univerx/features/home/homePage.dart';
import 'package:univerx/services/neptun_API_fetching.dart';
import 'package:univerx/features/common/widgets/box_3d.dart';
import 'package:univerx/services/neptun_ICS_fetching.dart'; // Import the custom decorations

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController icsController = TextEditingController();
  
  bool loginEnabled = true;
  bool loggingIn = false;

  @override
  void initState() {
    super.initState();
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
      backgroundColor: const Color.fromARGB(255, 20, 18, 32),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'UniverX',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3.0,
                    ),
                  ),
                  const SizedBox(height: 24.0), // Space between the title and the first input field

                  TextField(
                    controller: icsController,
                    decoration: InputDecoration(
                      hintText: 'exportált naptár link',
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
                    enabled: !loggingIn,
                  ),
                  const SizedBox(height: 30.0),
                  Container(
                    width: 175,
                    decoration: Box3D(),
                    // Apply the custom box decoration
                    child: Container(
                      margin: EdgeInsets.all(1), // Adjust this value to change the border width
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 38, 51, 70),
                      ),
                      child: ElevatedButton(
                        onPressed: loginEnabled
                            ? () async {
                                setState(() {
                                  loginEnabled = false;
                                  loggingIn = true;
                                });

                                final icsLink = icsController.text;

                                if (icsLink != "") {
                                  if (true) {
                                    await DatabaseHelper.instance.saveCalendarICS(
                                      icsLink
                                    );
                                    EventService eventService = EventService(icsLink);
                                    await eventService.fetchAndUpdateIcs();                                    
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Home()), // Ensure Home is correctly imported
                                    );
                                  } 
                                } else {
                                  print('Missing details');
                                  _showWrongPasswordPopup();
                                }

                                setState(() {
                                  loginEnabled = true;
                                  loggingIn = false;
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 0, // Remove button shadow
                        ),
                        child: loggingIn
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'v0.4.3 beta',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontFamily: "sfpro",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
