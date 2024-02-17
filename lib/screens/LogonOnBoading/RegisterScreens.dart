import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recicle/services/Auth_Services.dart';
import 'package:recicle/widgets/registerButtons/FaceBoockRegisterButton.dart';
import 'package:recicle/widgets/registerButtons/GoogleRegisterButton.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool haveError = false;
  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Register'),
        backgroundColor: Colors.white12,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "Register",
                            style: TextStyle(
                                color: Color.fromARGB(186, 0, 0, 0),
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                      labelText: 'Password',
                                      hintText: "Password"),
                                  controller: passwordController),
                              haveError
                                  ? Text(
                                      errorMessage,
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : Text(''),
                              const SizedBox(
                                height: 20,
                              ),
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
                                  setState(() {
                                    isLoading = true;
                                  });
                                  register();
                                },
                                child: SizedBox(
                                  height: 50,
                                  width: 290,
                                  child: Center(
                                    child: isLoading
                                        ? CircularProgressIndicator()
                                        : Text(
                                            'Continue',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 25),
                                          ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: InkWell(
                                  child: const Row(
                                    children: [
                                      Text("Deja un compte ?",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15)),
                                      Text(
                                        "se connecter.",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // GoogleRegisterButton(),
                              // FaceBoockRegisterButton()
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  register() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      AuthService()
          .RegisterWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        if (value) {
          Navigator.pushReplacementNamed(context, "/home");
        } else {
          setState(() {
            haveError = true;
            errorMessage = value;
            isLoading = false;
          });
        }
        setState(() {
          isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          haveError = true;
          errorMessage = error.toString();
          isLoading = false;
        });
      });
    } else {
      print("email ou mot de passe vide");
      errorMessage =
          "email: ${emailController.text} password: ${passwordController.text}";
      //alert dialog
    }
  }
}
