import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart'; // Importing your ProfileMenu widget

class Settings extends StatelessWidget {
  const Settings({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "UniX-PTE-TTK",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily:
                "sfpro", // Change 'YourFontFamily' to your desired font family
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate back to the home page
              Navigator.pop(context);
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Color.fromARGB(255, 77, 86, 139),
                fontSize: 16.0,
                fontFamily:
                    "sfpro", // Change 'YourFontFamily' to your desired font family
              ),
            ),
          ),
        ],
      ),
      endDrawer: const DrawerMenu(), //Profile_menu pop up
      body: Container(
        color: Colors.black,
      ),
    );
  }
}
