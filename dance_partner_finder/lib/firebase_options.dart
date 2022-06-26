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
    apiKey: 'AIzaSyDOlQIxuxIEDCXbv5NUL2tevLN52ehCNss',
    appId: '1:948788582778:web:a9d66e4e09a8ae3decdec3',
    messagingSenderId: '948788582778',
    projectId: 'wonderland-007',
    authDomain: 'wonderland-007.firebaseapp.com',
    storageBucket: 'wonderland-007.appspot.com',
    measurementId: 'G-X2MBM59KX4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2PHRrVctb55VqBbr54thAoTPXwCKWhiU',
    appId: '1:948788582778:android:267663f3f7f33fa4ecdec3',
    messagingSenderId: '948788582778',
    projectId: 'wonderland-007',
    storageBucket: 'wonderland-007.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7wYPPcBiNXCa37Yc5zOmKttytVUeusJw',
    appId: '1:948788582778:ios:481dfae396b3d9afecdec3',
    messagingSenderId: '948788582778',
    projectId: 'wonderland-007',
    storageBucket: 'wonderland-007.appspot.com',
    androidClientId: '948788582778-8mnc43d0naqvhibo7j9d3t5agpn9cv9a.apps.googleusercontent.com',
    iosClientId: '948788582778-15jr2hqnpvoc57p79pi8rt52rp09hn9p.apps.googleusercontent.com',
    iosBundleId: 'wonderland.dance.partner.finder.dancePartnerFinder',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB7wYPPcBiNXCa37Yc5zOmKttytVUeusJw',
    appId: '1:948788582778:ios:481dfae396b3d9afecdec3',
    messagingSenderId: '948788582778',
    projectId: 'wonderland-007',
    storageBucket: 'wonderland-007.appspot.com',
    androidClientId: '948788582778-8mnc43d0naqvhibo7j9d3t5agpn9cv9a.apps.googleusercontent.com',
    iosClientId: '948788582778-15jr2hqnpvoc57p79pi8rt52rp09hn9p.apps.googleusercontent.com',
    iosBundleId: 'wonderland.dance.partner.finder.dancePartnerFinder',
  );
}
