import 'package:flutter/material.dart';
import 'package:univerx/features/appointment/OLD_appointmentPage.dart';
import 'package:univerx/features/exams/examsPage.dart';
import 'package:univerx/features/neptun_login/login.dart';
import 'package:univerx/features/settings/settingsPage.dart';
import 'package:univerx/features/neptun_login/data/logout.dart';
import 'package:univerx/database/database_helper.dart';
import 'package:univerx/models/assignment.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import for launching URLs

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  Future<String> _getUsername() async {
    var result = await DatabaseHelper.instance.getNeptunLogin();
    if (result != null && result is Map<String, dynamic>) {
      String username = result["login"] as String;
      return username.isNotEmpty ? username : "-";
    }
    return "-";
  }

  // Function to launch URLs
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 20, 18, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60.0), // Space between top and text
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
                String usernameInitial = snapshot.data ?? '-';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 38, 51, 70),
                        child: Text(
                          usernameInitial[0],
                          style: const TextStyle(color: Colors.white, fontFamily: "sfpro"),
                        ),
                      ),
                      const SizedBox(width: 20.0), // Adjust the width as needed
                      Text(
                        snapshot.data ?? '',
                        style: const TextStyle(
                          letterSpacing: 3,
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: "sfpro",
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 20.0), // Space between text and tiles
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Home',
                style: TextStyle(
                  letterSpacing: 2,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: "sfpro",
                )),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag, color: Colors.white),
            title: const Text('Assignments',
                style: TextStyle(
                  letterSpacing: 2,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: "sfpro",
                )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Appointment()),
              );
            },
          ),
          /*
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('Settings',
                style: TextStyle(
                  letterSpacing: 2,
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
          */
          ListTile(
            leading: const Icon(Icons.logout, color: Color.fromARGB(255, 175, 38, 38)),
            title: const Text('Logout',
                style: TextStyle(
                  letterSpacing: 2,
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
          Spacer(), // Push the footer to the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.mail, color: Colors.white),
                      onPressed: () {
                        _launchURL('mailto:szilagyibencee@gmail.com');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.code, color: Colors.white),
                      onPressed: () {
                        _launchURL('https://github.com/31b4/univerx');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.discord, color: Colors.white),
                      onPressed: () {
                        _launchURL('https://discord.gg/Byyswbmcqz');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                const Text(
                  'v0.4.3 beta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontFamily: "sfpro",
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
