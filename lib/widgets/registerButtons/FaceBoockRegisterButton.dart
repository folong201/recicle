import 'package:flutter/material.dart';

class FaceBoockRegisterButton extends StatefulWidget {
  const FaceBoockRegisterButton({super.key});

  @override
  State<FaceBoockRegisterButton> createState() =>
      _FaceBoockRegisterButtonState();
}

class _FaceBoockRegisterButtonState extends State<FaceBoockRegisterButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey[200],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 13.0, bottom: 13.0, left: 30.0, right: 30.0),
              child: Row(
                children: [
                  Image.asset("assets/images/facebook.png"),
                  SizedBox(width: 20),
                  Text(
                    "Register with FaceBook",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomeScreen()),
        // );
      },
    );
  }
}
