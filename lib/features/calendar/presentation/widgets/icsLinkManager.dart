import 'package:flutter/material.dart';

class CustomImportButton extends StatelessWidget {
  // add onpress function a required parameter

  final VoidCallback onPressed;

  const CustomImportButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        backgroundColor: Color.fromARGB(255, 20, 21, 27),
      ),
      child: const Text(
        'Import',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
