import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recicle/helpers/colors.dart';
import 'package:recicle/screens/HomeScreen.dart';
import 'package:recicle/screens/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


 