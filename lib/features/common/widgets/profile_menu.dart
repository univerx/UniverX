import 'package:flutter/material.dart';
import 'package:univerx/features/neptun_login/presentation/pages/login.dart';
import 'package:univerx/features/settings/presentation/pages/settingsPage.dart';
import 'package:univerx/features/neptun_login/data/logout.dart';

import 'package:univerx/database/database_helper.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  Future<String> _getUsername() async {
    var result = await DatabaseHelper.instance.getNeptunLogin();
    if (result != null && result is Map<String, dynamic>) {
      return result["login"] as String;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0), // Space between top and text
              FutureBuilder<String>(
                future: _getUsername(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Error',
                      style: TextStyle(color: Colors.white, fontFamily: "sfpro"),
                    );
                  } else {
                    return Row(
                      children: [
                        const SizedBox(width: 10.0), // Adjust the width as needed
                        const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 20, 21, 27),
                          child: Text(
                            "D",
                            style: TextStyle(color: Colors.white, fontFamily: "sfpro"),
                          ),
                        ),
                        Text(
                          snapshot.data ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: "sfpro",
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20.0), // Space between text and tiles
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text('Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "sfpro",
                    )),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text('Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "sfpro",
                    )),
                onTap: () {
                  // Handle navigation to Settings
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Color.fromARGB(255, 175, 38, 38)),
                title: const Text('Logout',
                    style: TextStyle(
                      color: Color.fromARGB(255, 175, 38, 38),
                      fontSize: 16.0,
                      fontFamily: "sfpro",
                    )),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Dismiss the dialog
                            },
                          ),
                          TextButton(
                            child: Text('Logout'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Dismiss the dialog
                              // Handle navigation to Logout
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                              // Add navigation code here
                              logout();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
