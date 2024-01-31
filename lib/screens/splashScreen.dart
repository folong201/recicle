import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recicle/screens/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer(
    //   Duration(seconds: 8),
    //   () => Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const HomeScreen()),
    //   ),
    // );
  }

  void goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Recicle.png'),
            // FlutterLogo(size: MediaQuery.of(context).size.height * 0.5),
           const  SizedBox(height: 20),
            ElevatedButton(
              onPressed: goToHome,
              child: const Text('Passer'),
            ),
          ],
        ),
      ),
    );
  }
}
