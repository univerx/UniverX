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
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.5, -0.6),
            radius: 1.0,
            colors: [
              Colors.blueAccent.withOpacity(0.6),
              Colors.pinkAccent.withOpacity(0.4),
              Colors.transparent,
            ],
            stops: [0.1, 0.5, 1.0],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.purpleAccent.withOpacity(0.2),
                Colors.transparent,
              ],
              stops: [0.3, 0.6, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CustomScrollView(
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
                      color: Colors.black.withOpacity(0.5),
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
        ),
      ),
    );
  }
}
