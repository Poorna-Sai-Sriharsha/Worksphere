import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  // Firebase Web configuration — these are client-side values, safe to commit.
  // Security is enforced by Firebase Authentication and Firestore Security Rules.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA1CJ89MXTkt1AIe3paCuYlI_rAbQJZXZE',
    appId: '1:279899746993:web:11819750a7d6f88a172890',
    messagingSenderId: '279899746993',
    projectId: 'worksphere-8709b',
    authDomain: 'worksphere-8709b.firebaseapp.com',
    storageBucket: 'worksphere-8709b.firebasestorage.app',
  );
}
