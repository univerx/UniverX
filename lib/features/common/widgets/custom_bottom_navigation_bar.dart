import 'package:flutter/material.dart';
//----------------------- pages ----------------------
import 'package:univerx/features/assignments/assignmentsPage.dart';
import 'package:univerx/features/common/widgets/box_3d.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

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
        _navigateToHome();
        break;
      case 1:
        _navigateToAssignments();
        break;
      case 2:
        _navigateToNotes();
        break;
    }
  }

  void _navigateToHome() {
    // Handle navigation to Home
    print('Navigating to Home');
  }

  void _navigateToAssignments() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Assignments()),
    );
  }

  void _navigateToNotes() {
    // Handle navigation to Notes
    print('Navigating to Notes');
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          width: double.infinity,
          height: 1.0,
          color: Color.fromARGB(36, 255, 255, 255),
        ),
        BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            _buildBottomNavigationBarItem(Icons.home, 'Home'),
            _buildBottomNavigationBarItem(Icons.shopping_bag, 'Assignments'),
            _buildBottomNavigationBarItem(Icons.note, 'Nothing'),
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
        ),
      ],
    );
  }
}
