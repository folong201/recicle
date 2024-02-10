import 'package:flutter/material.dart';

class ResetEmailOk extends StatelessWidget {
  const ResetEmailOk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/login");
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/emailsent.png",
                  height: 100,
                  width: 100,
                  // color: Colors.red,
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      // primary: Colors.black87,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Text('Se Connecter.'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
