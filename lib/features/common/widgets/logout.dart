import 'package:flutter/material.dart';
import 'package:univerx/features/login/login.dart';

Future<void> showLogoutDialog(BuildContext context, VoidCallback logout) {
  return showDialog<void>(
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
              // Call the logout function
              logout();
            },
          ),
        ],
      );
    },
  );
}
