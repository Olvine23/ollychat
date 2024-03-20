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
    apiKey: 'AIzaSyAsc8FOIkKT-WbL_CEDN1M7ZeorVvaEwDU',
    appId: '1:917165240645:web:376f1b40a1d84b7d26ce2c',
    messagingSenderId: '917165240645',
    projectId: 'voice-hub-2a9f4',
    authDomain: 'voice-hub-2a9f4.firebaseapp.com',
    storageBucket: 'voice-hub-2a9f4.appspot.com',
    measurementId: 'G-FF8Y6D3MJB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9iKpkpQlP-KP6lJiBvCMk5Vtf44I-r2I',
    appId: '1:917165240645:android:e94490eabf7fac9f26ce2c',
    messagingSenderId: '917165240645',
    projectId: 'voice-hub-2a9f4',
    storageBucket: 'voice-hub-2a9f4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDO7SRjsmSDE0GANt8MxcKhUfElMD8_nxc',
    appId: '1:917165240645:ios:9ab04c7e07d495f126ce2c',
    messagingSenderId: '917165240645',
    projectId: 'voice-hub-2a9f4',
    storageBucket: 'voice-hub-2a9f4.appspot.com',
    iosClientId: '917165240645-3jqa5ffg1anldh9nva9g51q2ereb13c6.apps.googleusercontent.com',
    iosBundleId: 'com.example.ollyChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDO7SRjsmSDE0GANt8MxcKhUfElMD8_nxc',
    appId: '1:917165240645:ios:ff39dd164afe401526ce2c',
    messagingSenderId: '917165240645',
    projectId: 'voice-hub-2a9f4',
    storageBucket: 'voice-hub-2a9f4.appspot.com',
    iosClientId: '917165240645-237e121buffh9v29ft0o4aubiraebsj8.apps.googleusercontent.com',
    iosBundleId: 'com.example.ollyChat.RunnerTests',
  );
}
