import 'package:flutter/material.dart';
import 'package:univerx/features/home/presentation/pages/homePage.dart';





class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Widget? icsButton;


  // ---------------------Requirement Title--------------------------
  DefaultAppBar({
    required this.title,
    this.showBackButton = false,
    this.icsButton,
  });

  // ---------------------AppBar--------------------------
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        
        IconButton(
          onPressed: (){
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
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
