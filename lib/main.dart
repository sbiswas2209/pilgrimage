import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pilgrimage/pages/home.dart';
import 'package:pilgrimage/pages/intro.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilgrimage',
      home: IntroPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber,
        buttonColor: Colors.amber,
        fontFamily: 'Ubuntu',
        backgroundColor: Colors.black,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 25.0,
          ),
          bodyText1: TextStyle(
            fontSize: 15.0,
          )
        )
      ),
    );
  }
}