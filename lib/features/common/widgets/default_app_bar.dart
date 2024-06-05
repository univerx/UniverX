import 'package:flutter/material.dart';
import 'package:univerx/features/home/presentation/pages/homePage.dart';

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

      backgroundColor: Colors.black,
      elevation: 0,
      actions: [
        if (icsButton != null) icsButton!,
        
        if (showProfileMenu) IconButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          icon: const CircleAvatar(
            backgroundColor: Color.fromARGB(255, 20, 21, 27),
            child: Text(
              "D",
              style: TextStyle(color: Colors.white, fontFamily: "sfpro"),
            ),
          ),
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
