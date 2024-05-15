import 'package:flutter/material.dart';
import 'package:univerx/pages/home.dart';


class Assigments extends StatelessWidget {
  const Assigments({Key? key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Assigment manager",
                style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), color: Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              // Navigate back to the home page with a custom animation
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => Home(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(-1.0, 0.0); // Adjusted for left to right slide
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                // to second page
                //Navigator.pushNamed(context, '/second');
              },
              icon: 
                const CircleAvatar(
                  backgroundColor: Colors.blue, // Change the color as needed
                  child: Text(
                    "D", // Replace with your letter
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            )],
        ),
        
        body: Center(child: Text("asd"),)
      ),
    );
  }
}
