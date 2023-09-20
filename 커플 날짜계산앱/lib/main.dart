import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hello_world/screen/home_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'sunflower',
      textTheme: TextTheme(
        headline1: TextStyle(
          color: Colors.white,
          fontSize: 80,
          fontWeight: FontWeight.w700,
          fontFamily: 'parisienne',
        ),
        headline2: TextStyle(
          color: Colors.white,
          fontSize: 50,
          fontWeight: FontWeight.w700,
        ),
        bodyText1: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      )
    ),
    home: HomeScreen(),
  ));
}


