import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recicle/screens/HomeScreen.dart';
import 'package:recicle/screens/LogonOnBoading/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAuth = false;
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => {
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => const HomeScreen()),
        //   )
        checkIfAuth()
      },
    );
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
      backgroundColor: Colors.purple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/recicle.png"),
            const SizedBox(height: 50),
            CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.purple,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: goToHome,
              child: const Text('Passer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkIfAuth() async {
    if (isAuth) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
