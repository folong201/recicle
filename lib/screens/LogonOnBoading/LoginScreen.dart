import 'package:flutter/material.dart';
import 'package:recicle/screens/LogonOnBoading/RegisterScreens.dart';
import 'package:recicle/services/Auth_Services.dart';
import 'package:recicle/widgets/LoginButtons/FaceBoockLoginButton.dart';
import 'package:recicle/widgets/LoginButtons/GoogleLoginButton.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool haveError = false;

  String errorMessage = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: !isLoading
          ? SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Login",
                        style: TextStyle(
                            color: const Color.fromARGB(154, 0, 0, 0),
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: "Email",
                              border: UnderlineInputBorder(),
                            ),
                            controller: emailController,
                          ),
                          SizedBox(height: 12),

                          TextField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                  labelText: 'Password', hintText: "Password"),
                              controller: passwordController),
                          haveError
                              ? Text(
                                  errorMessage,
                                  style: TextStyle(color: Colors.red),
                                )
                              : Text(''),

                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: InkWell(
                              child: const Row(
                                children: [
                                  Text("Mot de passe oublier ? ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15)),
                                  Text(
                                    " Reset .",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Colors.purple),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/resetpassword');
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          // LinkWell
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              loginuser(context);
                            },
                            child: const SizedBox(
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
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: InkWell(
                              child: const Row(
                                children: [
                                  Text("Pas de compte ? ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15)),
                                  Text(
                                    "creer en un.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Colors.purple),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/register');
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const GoogleLoginButton(),
                          const SizedBox(
                            height: 16,
                          ),
                          const FaceBoockLoginButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  loginuser(context) async {
    print("login user");
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await AuthService()
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        if (value == true) {
          print("login success");
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          print("login failed");
          setState(() {
            haveError = true;
            errorMessage = "Email ou mot de passe incorrect";
            isLoading = false;
          });
        }
      }).catchError((onError) {
        print("error");
        setState(() {
          haveError = true;
          errorMessage = onError.toString();
          isLoading = false;
        });
      });
    } else {
      print("error");
      setState(() {
        haveError = true;
        errorMessage = "Veuillez remplir tous les champs";
        isLoading = false;
      });
    }
  }
}
