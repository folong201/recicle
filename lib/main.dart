import 'package:flutter/material.dart';
import 'package:recicle/screens/HomeScreen.dart';
import 'package:recicle/screens/LogonOnBoading/LoginScreen.dart';
import 'package:recicle/screens/LogonOnBoading/RegisterScreens.dart';
import 'package:recicle/screens/LogonOnBoading/ResetEmailOkScreen.dart';
import 'package:recicle/screens/ProductDetails.dart';
import 'package:recicle/screens/ResetPassword.dart';
import 'package:recicle/screens/splashScreen.dart';

// import 'package:recicle/screens/Messages/DetailsPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFF8E6CEF,
          <int, Color>{
            50: Color(0xFFEAE2F7),
            100: Color(0xFFD4B5EF),
            200: Color(0xFFBD87E7),
            300: Color(0xFFA659DF),
            400: Color(0xFF8E6CEF),
            500: Color(0xFF7549E7),
            600: Color(0xFF5C3CD0),
            700: Color(0xFF432FB9),
            800: Color(0xFF2A229F),
            900: Color(0xFF110583),
          },
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/resetpassword': (context) => ResetPasswordScreen(),
        '/resetpasswordok': (context) => ResetEmailOk(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
