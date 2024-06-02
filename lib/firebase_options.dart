// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyB7PXuK-lgHF7MgJeoWYPuQ-2-pnRSvu0w',
    appId: '1:482150639136:web:219725dafb39a383887e45',
    messagingSenderId: '482150639136',
    projectId: 'alpha-test-proj',
    authDomain: 'alpha-test-proj.firebaseapp.com',
    storageBucket: 'alpha-test-proj.appspot.com',
    measurementId: 'G-DBTSVWPP3F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfKGAoV6ENp_aalG2Kx0953R7lmA9vwYU',
    appId: '1:482150639136:android:0251937dfd3a9528887e45',
    messagingSenderId: '482150639136',
    projectId: 'alpha-test-proj',
    storageBucket: 'alpha-test-proj.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgyV4K6dWG0QUDwgRf4M6XnMckmdngeDI',
    appId: '1:482150639136:ios:e4c0aceeea62f8f0887e45',
    messagingSenderId: '482150639136',
    projectId: 'alpha-test-proj',
    storageBucket: 'alpha-test-proj.appspot.com',
    iosBundleId: 'com.example.fpGolekost',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDgyV4K6dWG0QUDwgRf4M6XnMckmdngeDI',
    appId: '1:482150639136:ios:e4c0aceeea62f8f0887e45',
    messagingSenderId: '482150639136',
    projectId: 'alpha-test-proj',
    storageBucket: 'alpha-test-proj.appspot.com',
    iosBundleId: 'com.example.fpGolekost',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB7PXuK-lgHF7MgJeoWYPuQ-2-pnRSvu0w',
    appId: '1:482150639136:web:5ae9027e99c83033887e45',
    messagingSenderId: '482150639136',
    projectId: 'alpha-test-proj',
    authDomain: 'alpha-test-proj.firebaseapp.com',
    storageBucket: 'alpha-test-proj.appspot.com',
    measurementId: 'G-3ZMD7NYS8T',
  );
}
