 import 'package:flutter/material.dart';
import 'package:recicle/screens/Home/Settings.dart';
import 'package:recicle/screens/HomeScreen.dart';
import 'package:recicle/screens/LogonOnBoading/LoginScreen.dart';
import 'package:recicle/screens/LogonOnBoading/RegisterScreens.dart';
import 'package:recicle/screens/LogonOnBoading/ResetEmailOkScreen.dart';
import 'package:recicle/screens/ResetPassword.dart';
import 'package:recicle/screens/splashScreen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

// import 'package:recicle/screens/Messages/DetailsPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //   // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
  //   // argument for `webProvider`
  //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  //   // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Safety Net provider
  //   // 3. Play Integrity provider
  //   androidProvider: AndroidProvider.debug,
  //   // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Device Check provider
  //   // 3. App Attest provider
  //   // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
  //   appleProvider: AppleProvider.appAttest,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/resetpassword': (context) => const ResetPasswordScreen(),
        '/resetpasswordok': (context) => const ResetEmailOk(),
        '/editProfile': (context) => const SettingsScreen()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
