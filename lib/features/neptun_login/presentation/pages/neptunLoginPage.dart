import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univerx/features/calendar/data/datasources/fetchAndUpdateApi.dart';
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';
import 'package:univerx/database/database_helper.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:univerx/features/neptun_login/data/neptunApi.dart';

class NeptunLogin extends StatefulWidget {
  const NeptunLogin({Key? key}) : super(key: key);

  @override
  _NeptunLoginState createState() => _NeptunLoginState();
}

class _NeptunLoginState extends State<NeptunLogin> {
  final TextEditingController neptunController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  List<dynamic> universities = [];
  String? selectedUniversity;
  String? selectedUniversityUrl;
  bool hasLoginData = false;

  @override
  void initState() {
    super.initState();
    _loadLoginDetails();
    _loadUniversities();
  }

  Future<void> _loadLoginDetails() async {
    var loginDetails = await DatabaseHelper.instance.getNeptunLogin();
    if (loginDetails != null) {
      var details = loginDetails as Map<String, dynamic>;
      setState(() {
        selectedUniversity = details['university'];
        selectedUniversityUrl = details['url'];
        neptunController.text = details['login'] ?? '';
        passwordController.text = details['password'] ?? '';
        hasLoginData = true;
      });
      fetchCalendar(details['url'], details['login'], details['password']);
    }
  }

  Future<void> _loadUniversities() async {
    String data = await rootBundle.loadString('lib/features/neptun_login/data/Institutes.json');
    setState(() {
      universities = json.decode(data);
    });
  }

  void _logout() async {
    await DatabaseHelper.instance.deleteNeptunLogin();
    await DatabaseHelper.instance.clearAllEvents();
    setState(() {
      selectedUniversity = null;
      selectedUniversityUrl = null;
      neptunController.clear();
      passwordController.clear();
      hasLoginData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: <Widget>[
          DefaultAppBar(
            title: 'Neptun Login',
            showBackButton: true,
            showProfileMenu: false,
            showDoneButton: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  color: Colors.black,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'University',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 8.0),
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
                      SizedBox(height: 16.0),
                      Text(
                        'Neptun Code',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: neptunController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: 'Enter Neptun Code',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Password',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: 'Enter Password',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Center(
                        child: hasLoginData
                          ? ElevatedButton(
                              onPressed: _logout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              ),
                              child: Text('Logout'),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                final neptunCode = neptunController.text;
                                final password = passwordController.text;

                                if (selectedUniversityUrl != null) {
                                  DatabaseHelper.instance.saveNeptunLogin(
                                    selectedUniversity!,
                                    selectedUniversityUrl!,
                                    neptunCode,
                                    password
                                  );

                                  // neptun api
                                  fetchAndUpdateApi();

                                  setState(() {
                                    hasLoginData = true;
                                  });
                                  print('University URL: $selectedUniversityUrl');
                                } else {
                                  print('No URL found for the selected university');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              ),
                              child: Text('Login'),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
