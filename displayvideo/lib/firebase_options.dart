// TODO Implement this library.
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
    apiKey: 'AIzaSyDrmF0MHMh-pFEgM2Uu95N-gQ9XgF4nuyI',
    appId: '1:556484525831:web:c2606cc6fbb3139c34cfa2',
    messagingSenderId: '556484525831',
    projectId: 'uplaod-faculty-foresthacks',
    authDomain: 'uplaod-faculty-foresthacks.firebaseapp.com',
    storageBucket: 'uplaod-faculty-foresthacks.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXfESipQMvm78wNdkZKh4pu0FWzdUW_vE',
    appId: '1:556484525831:android:5a463fd15ff0ae0e34cfa2',
    messagingSenderId: '556484525831',
    projectId: 'uplaod-faculty-foresthacks',
    storageBucket: 'uplaod-faculty-foresthacks.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8Fe0eljD2rDKzvdRiY7ujVuRQCrzkHeo',
    appId: '1:556484525831:ios:c67ec3e9e7315a4d34cfa2',
    messagingSenderId: '556484525831',
    projectId: 'uplaod-faculty-foresthacks',
    storageBucket: 'uplaod-faculty-foresthacks.appspot.com',
    iosBundleId: 'com.example.storing',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB8Fe0eljD2rDKzvdRiY7ujVuRQCrzkHeo',
    appId: '1:556484525831:ios:c67ec3e9e7315a4d34cfa2',
    messagingSenderId: '556484525831',
    projectId: 'uplaod-faculty-foresthacks',
    storageBucket: 'uplaod-faculty-foresthacks.appspot.com',
    iosBundleId: 'com.example.storing',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDrmF0MHMh-pFEgM2Uu95N-gQ9XgF4nuyI',
    appId: '1:556484525831:web:2f34efcfbfd684aa34cfa2',
    messagingSenderId: '556484525831',
    projectId: 'uplaod-faculty-foresthacks',
    authDomain: 'uplaod-faculty-foresthacks.firebaseapp.com',
    storageBucket: 'uplaod-faculty-foresthacks.appspot.com',
  );

}