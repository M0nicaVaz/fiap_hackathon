import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return crossPlatform;
  }

  //TODO: Adicionar firebase real
  static const FirebaseOptions crossPlatform = FirebaseOptions(
    apiKey: 'REPLACE_WITH_WEB_API_KEY',
    appId: '1:1234567890:web:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'fiap-hackathon-dev',
    authDomain: 'fiap-hackathon-dev.firebaseapp.com',
    storageBucket: 'fiap-hackathon-dev.appspot.com',
    measurementId: 'G-XXXXXXXXXX',
  );
}
