import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recicle/screens/HomeScreen.dart';
import 'package:recicle/screens/LogonOnBoading/LoginScreen.dart';
import 'package:recicle/services/helper_function.dart';

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
    setAuthStatus();
  }

  setAuthStatus() async {
    print("verification du status");
    HelperFunction.getUserLoggedInSharedPreference().then((value) {
      print("valeur recupere: $value");
      setState(() {
        isAuth = value ?? false;
      });
      if (isAuth == false || isAuth == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        goToHome();
      }
    });
  }

  void goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
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
}
