// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDe19fQQ5cfz2wMSN0i77iYZLfdNR0tkRg',
    appId: '1:232621482154:web:73f53dd83b443481b3b0d3',
    messagingSenderId: '232621482154',
    projectId: 'recicle-47b34',
    authDomain: 'recicle-47b34.firebaseapp.com',
    storageBucket: 'recicle-47b34.appspot.com',
    measurementId: 'G-GSD1RY0S2G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBINOC-GXh-rvO1LAvrPbp7vR_xMvDmF8',
    appId: '1:232621482154:android:9f67daebd4a5245cb3b0d3',
    messagingSenderId: '232621482154',
    projectId: 'recicle-47b34',
    storageBucket: 'recicle-47b34.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBT8F5Lv_bNilkVyR9YrVZntvhLX7dT66s',
    appId: '1:232621482154:ios:ffe822cb6759cf32b3b0d3',
    messagingSenderId: '232621482154',
    projectId: 'recicle-47b34',
    storageBucket: 'recicle-47b34.appspot.com',
    iosClientId: '232621482154-dmdn2nie324qsn1leomc6v2hecdcsoir.apps.googleusercontent.com',
    iosBundleId: 'com.example.recicle',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBT8F5Lv_bNilkVyR9YrVZntvhLX7dT66s',
    appId: '1:232621482154:ios:b2e639242b0b048bb3b0d3',
    messagingSenderId: '232621482154',
    projectId: 'recicle-47b34',
    storageBucket: 'recicle-47b34.appspot.com',
    iosClientId: '232621482154-qlt11k3h51sqjfiuairva1mjc8h46dqh.apps.googleusercontent.com',
    iosBundleId: 'com.example.recicle.RunnerTests',
  );
}
