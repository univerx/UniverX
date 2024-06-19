// lib/widgets/calendar_widget.dart

import 'package:flutter/material.dart';
import 'package:univerx/features/common/widgets/box_3d.dart';

class UpcomingContainer extends StatelessWidget {
  final BuildContext homeContext;
  final String title;
  final String date; // Add a date parameter

  UpcomingContainer({
    required this.homeContext,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Expanded(
          flex: 2,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(homeContext, '/events'),
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 10), // Added top margin here
                height: 52,
                decoration: Box3D(),
                child: Container(
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 38, 51, 70),
                  ),
                  padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0), // Adjust this value to change the border width
                  alignment: Alignment.centerLeft,

                  

                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}
