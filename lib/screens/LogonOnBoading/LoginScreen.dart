import 'package:flutter/material.dart';
import 'package:recicle/screens/LogonOnBoading/RegisterScreens.dart';
import 'package:recicle/widgets/LoginButtons/FaceBoockLoginButton.dart';
import 'package:recicle/widgets/LoginButtons/GoogleLoginButton.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = new TextEditingController();
    final TextEditingController passwordController =
        new TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Login",
                  style: TextStyle(
                      color: const Color.fromARGB(154, 0, 0, 0),
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                ),
                SizedBox(
                  height: 40,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: "Email",
                        border: UnderlineInputBorder(),
                      ),
                      controller: emailController,
                    ),
                    SizedBox(height: 12),

                    TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password', hintText: "Password"),
                        controller: passwordController),

                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: InkWell(
                        child: Row(
                          children: [
                            Text("Pas de compte ? ,",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15)),
                            Text(
                              "creer en un.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => RegisterScreen())));
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    // LinkWell
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        // Perform login logic here
                      },
                      child: SizedBox(
                        height: 50,
                        width: 310,
                        child: Center(
                            child: Text(
                          'Continue',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 25),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GoogleLoginButton(),
                    SizedBox(
                      height: 16,
                    ),
                    FaceBoockLoginButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
