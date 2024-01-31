import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Register with:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            // SignInButton(
            //   Buttons.Google,
            //   onPressed: () {
            //     // Handle Google authentication
            //   },
            // ),
            SizedBox(height: 10),
            // SignInButton(
            //   Buttons.Facebook,
            //   onPressed: () {
            //     // Handle Facebook authentication
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
