import 'package:flutter/material.dart';



class GoogleLoginButton extends StatefulWidget {
  const GoogleLoginButton({super.key});

  @override
  State<GoogleLoginButton> createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton> {
  @override
  Widget build(BuildContext context) {
    return 
      Container(
        child: Row(
          children: [
            Text("Login with Google")
          ],
        ),
      )
    ;
  }
}