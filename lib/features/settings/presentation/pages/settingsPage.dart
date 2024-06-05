import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: <Widget>[
          DefaultAppBar(
            title: 'Settings',
            showBackButton: true,
            showProfileMenu: false,
            showDoneButton: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Add your settings widgets here
                Container(
                  color: Colors.black,
                  child: Column(
                    children: [
                      // Your settings widgets go here
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
