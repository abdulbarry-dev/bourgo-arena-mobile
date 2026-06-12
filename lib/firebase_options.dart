import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:bourgo_arena_mobile/core/config/app_config.dart';

/// Default [FirebaseOptions] for use with Firebase.
/// Values are loaded from environment variables via [AppConfig].
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: AppConfig.firebaseApiKey,
      appId: AppConfig.firebaseAppId,
      messagingSenderId: AppConfig.firebaseMessagingSenderId,
      projectId: AppConfig.firebaseProjectId,
    );
  }
}
