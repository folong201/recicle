import 'package:flutter/material.dart';

class FaceBoockLoginButton extends StatefulWidget {
  const FaceBoockLoginButton({super.key});

  @override
  State<FaceBoockLoginButton> createState() => _FaceBoockLoginButtonState();
}

class _FaceBoockLoginButtonState extends State<FaceBoockLoginButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [Text("Login with FaceBoock")],
      ),
    );
  }
}
