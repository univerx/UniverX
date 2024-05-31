import 'package:flutter/material.dart';

class RefreshIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(255, 20, 21, 27), // Set the desired background color here
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
