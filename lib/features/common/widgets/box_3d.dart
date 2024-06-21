// custom_decorations.dart
import 'package:flutter/material.dart';

BoxDecoration Box3D() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: LinearGradient(
      colors: [
        const Color.fromARGB(51, 255, 255, 255),
        const Color.fromARGB(51, 0, 0, 0),
        Color.fromARGB(51, 0, 0, 0)
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
      stops: [0.0, 0.84, 1.0],
    ),
    boxShadow: [
      
      BoxShadow(
        color: Color(0xFF2B3445).withOpacity(0.5),
        offset: Offset(0, -20),
        blurRadius: 30,
      ),
      BoxShadow(
        color: Color(0xFF10141C).withOpacity(1.0),
        offset: Offset(0, 20),
        blurRadius: 30,
      ),
    ],
  );
}
