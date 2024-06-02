import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/common/widgets/refresh_app_icon.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart'; 

class Settings extends StatelessWidget {
  const Settings({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: DefaultAppBar(
        title: 'Settings',
        showBackButton: true,
        showProfileMenu: false,
        showDoneButton: true,
      ),
      endDrawer: const DrawerMenu(), //Profile_menu pop up
      body: Container(
        color: Colors.black,
      ),
    );
  }
}
