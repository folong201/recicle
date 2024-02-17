import 'package:flutter/material.dart';
import 'package:recicle/services/Auth_Services.dart';

class GoogleRegisterButton extends StatefulWidget {
  const GoogleRegisterButton({super.key});

  @override
  State<GoogleRegisterButton> createState() => _GoogleRegisterButtonState();
}

class _GoogleRegisterButtonState extends State<GoogleRegisterButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey[200],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 13.0, bottom: 13.0, left: 30.0, right: 30.0),
          child: GestureDetector(
              child: Row(
                children: [
                  Image.asset("assets/images/google.png"),
                  const SizedBox(width: 20),
                  const Text(
                    "Register with Google",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () {
                AuthService().signInWithGoogle();
              }),
        ),
      ),
    );
  }
}
