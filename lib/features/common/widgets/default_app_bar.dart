import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:univerx/features/home/homePage.dart';
import 'package:univerx/database/database_helper.dart';

class DefaultAppBar extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final bool showProfileMenu;
  final bool showDoneButton;
  final Widget? icsButton;

  // ---------------------Requirement Title--------------------------
  DefaultAppBar({
    required this.title,
    this.showBackButton = false,
    this.showProfileMenu = true,
    this.showDoneButton = false,
    this.icsButton,
  });

  // ---------------------Get Username--------------------------
  Future<String> _getUsername() async {
    var result = await DatabaseHelper.instance.getNeptunLogin();
    if (result != null && result is Map<String, dynamic>) {
      String username = result["login"] as String;
      return username.isNotEmpty ? username[0] : "-";
    }
    return "-";
  }

  // ---------------------AppBar--------------------------
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontFamily: "sfpro",
            ),
          ),
        ],
      ),
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              color: Color.fromARGB(255, 255, 255, 255),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        if (icsButton != null) icsButton!,
        if (showProfileMenu) FutureBuilder<String>(
          future: _getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Optional: Show a loading indicator
            }
            String usernameInitial = snapshot.data ?? "-";
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 38, 51, 70),
                child: Text(
                  usernameInitial,
                  style: TextStyle(color: Colors.white, fontFamily: "sfpro"),
                ),
              ),
            );
          },
        ),
        if (showDoneButton) TextButton(
          onPressed: () {
            // Navigate back to the home page
            Navigator.pop(context);
            Navigator.pop(context); // nem vegleges xd
          },
          child: const Text(
            'Done',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 16.0,
              fontFamily: "sfpro", // Change 'YourFontFamily' to your desired font family
            ),
          ),
        ),
      ],
      pinned: false,
      floating: true,
      snap: true,
    );
  }
}
