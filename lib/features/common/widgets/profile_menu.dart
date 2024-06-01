import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF14151B), // Top left color (14151B)
              Color(0xFF747BA0), // Bottom left color (747BA0)
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: const Center(
          child: Text(
            'Coming soon...',
            style: TextStyle(
              color: Colors.white, // Text color
              fontSize: 20.0, // Text size
              fontFamily: "sfpro",
            ),
          ),
        ),
      ),
    );
  }
}
