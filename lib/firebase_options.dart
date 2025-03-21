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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBxQjdRq7GkZke1qhj8XyLjvx-bRRGoaPk',
    appId: '1:353985894147:web:56ee0d1dbe3ff2ef38bb36',
    messagingSenderId: '353985894147',
    projectId: 'ukk-kantin-e2bdf',
    authDomain: 'ukk-kantin-e2bdf.firebaseapp.com',
    storageBucket: 'ukk-kantin-e2bdf.firebasestorage.app',
    measurementId: 'G-VD9R77TYK2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3gMMzOxM1u9FdbvMf3PPdwdPag_gXOIw',
    appId: '1:353985894147:android:d7f24cd8cca7495438bb36',
    messagingSenderId: '353985894147',
    projectId: 'ukk-kantin-e2bdf',
    storageBucket: 'ukk-kantin-e2bdf.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2revetEYvgRKyQTSAAYUawCcexEVPDnI',
    appId: '1:353985894147:ios:d348afe16bcc3f0938bb36',
    messagingSenderId: '353985894147',
    projectId: 'ukk-kantin-e2bdf',
    storageBucket: 'ukk-kantin-e2bdf.firebasestorage.app',
    iosBundleId: 'com.example.ukkKantin',
  );
}
