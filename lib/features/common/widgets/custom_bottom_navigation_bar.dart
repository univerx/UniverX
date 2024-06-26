import 'package:flutter/material.dart';
import 'package:univerx/features/appointment/appointmentPage.dart';
import 'package:univerx/features/common/widgets/box_3d.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final VoidCallback button1;
  final VoidCallback button2;
  final VoidCallback button3;

  const CustomBottomNavigationBar({
    Key? key,
    required this.button1,
    required this.button2,
    required this.button3,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        widget.button1();
        break;
      case 1:
        widget.button2();
        break;
      case 2:
        widget.button3();
        break;
    }
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData iconData, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: Box3D(),
        child: Container(
          margin: EdgeInsets.all(1), // Adjust this value to change the border width
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 38, 51, 70),
          ),
          padding: EdgeInsets.all(8),
          child: Icon(iconData),
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        _buildBottomNavigationBarItem(Icons.home, 'Home'),
        _buildBottomNavigationBarItem(Icons.manage_search, 'Appointment'),
        _buildBottomNavigationBarItem(Icons.menu, 'Menu'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 20, 18, 32),
      selectedLabelStyle: const TextStyle(
        fontFamily: 'sfpro',
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'sfpro',
        fontWeight: FontWeight.bold,
      ),
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}
