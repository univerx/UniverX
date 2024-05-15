import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:univerx/pages/assignments.dart';
import 'package:univerx/pages/home.dart';
import 'package:univerx/pages/zh.dart';
import 'package:flutter/material.dart';



 
void main() async{
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        '/home': (context) => Home(),
        '/zh': (context) => Zh(),
        '/assigments':(context) => Assigments(),
        //'/second':(context) => Second(),
      } ,
    );
  }
}