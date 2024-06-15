import 'package:flutter/material.dart';
import 'package:univerx/features/neptun_login/presentation/pages/neptunLoginPage.dart';
import 'package:univerx/features/settings/presentation/pages/settingsPage.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFA3ACDE),
              Color(0xFFA3ACDE),
              Color(0xFF6E78A7),
              Color(0xFF545F8C),
              Color(0xFF3C4873),
              Color(0xFF23315A),
              Color(0xFF061D42),
              Color(0xFF00022C),
              Color(0xFF000116),
              Color(0xFF000000),
            ],
            stops: [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,1.0,],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40.0), // Adjust the height as needed
            const Center(
              child: Icon(
                Icons.menu, // Choose the icon you want to display
                color: Colors.white,
                size: 40.0, // Adjust the size as needed
              ),
            ),
            const SizedBox(height: 20.0), // Space between icon and text
            const Center(
              child: Text(
                'Coming soon...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: "sfpro",
                ),
              ),
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
                // Handle navigation to Home
                Navigator.pop(context); // Close the drawer
                // Add navigation code here
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
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Neptun Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: "sfpro",
                  )),
              onTap: () {
                // Handle navigation to Settings
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NeptunLogin()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
