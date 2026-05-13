import 'dart:io';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:flutter/foundation.dart';

/// Service for managing push notifications and device token registration.
///
/// This service handles capturing device tokens from push notification
/// providers (FCM for Android/iOS, or OneSignal) and storing them via
/// SessionRepository.
abstract interface class PushNotificationService {
  /// Initializes push notifications and captures device token.
  Future<void> initialize();

  /// Gets the currently stored device token.
  Future<String?> getToken();

  /// Manually refreshes and updates the device token.
  Future<void> refreshToken();

  /// Clears the stored device token on logout.
  Future<void> clearToken();
}

/// Default implementation using Firebase Cloud Messaging (FCM).
///
/// For iOS: Requires APNs certificate configuration in Firebase Console.
/// For Android: Requires Google Services JSON in android/app/google-services.json.
///
/// Token is automatically captured on initialization and stored via
/// SessionRepository.
class FirebaseMessagingService implements PushNotificationService {
  final SessionRepository _sessionRepository;

  FirebaseMessagingService(this._sessionRepository);

  /// Initializes Firebase Cloud Messaging and captures device token.
  @override
  Future<void> initialize() async {
    // Note: Actual Firebase Messaging initialization would go here
    // once firebase_messaging is added to pubspec.yaml
    //
    // Example implementation (when firebase_messaging is available):
    //
    // final messaging = FirebaseMessaging.instance;
    // final token = await messaging.getToken();
    // await _storeToken(token);
    //
    // messaging.onTokenRefresh.listen((newToken) {
    //   _storeToken(newToken);
    // });

    // Placeholder for now — this will be implemented once
    // firebase_messaging is added as a dependency
    _logDebug('Firebase Messaging service initialized');
  }

  /// Gets the currently stored device token from SharedPreferences.
  @override
  Future<String?> getToken() async {
    final result = await _sessionRepository.getDeviceToken();
    return result.isSuccess ? (result as dynamic).data as String? : null;
  }

  /// Refreshes the device token from FCM and updates storage.
  @override
  Future<void> refreshToken() async {
    // Example for when firebase_messaging is available:
    //
    // final messaging = FirebaseMessaging.instance;
    // final newToken = await messaging.getToken();
    // await _storeToken(newToken);

    _logDebug('Device token refresh triggered');
  }

  /// Clears the stored device token on logout.
  @override
  Future<void> clearToken() async {
    final currentToken = await getToken();
    if (currentToken != null) {
      await _sessionRepository.saveDeviceToken('');
      _logDebug('Device token cleared');
    }
  }

  /// Stores the device token and platform in SessionRepository.
  ///
  /// Called automatically when FCM token is refreshed.
  /// Currently a placeholder - will be wired when firebase_messaging is added.
  // ignore: unused_element
  Future<void> _storeToken(String? token) async {
    if (token == null || token.isEmpty) return;

    final result = await _sessionRepository.saveDeviceToken(token);
    result.when(
      success: (_) {
        _logDebug('Device token stored: $token');
        _storePlatformInfo();
      },
      failure: (failure) {
        _logDebug('Failed to store device token: ${failure.message}');
      },
    );
  }

  /// Stores the device platform (android/ios) in SessionRepository.
  Future<void> _storePlatformInfo() async {
    final platform = Platform.isAndroid
        ? 'android'
        : Platform.isIOS
        ? 'ios'
        : 'unknown';
    await _sessionRepository.saveDevicePlatform(platform);
    _logDebug('Device platform stored: $platform');
  }

  void _logDebug(String message) {
    if (kDebugMode) {
      // Using print for debug logging; in production use
      // dart:developer.log
      print('[PushNotificationService] $message');
    }
  }
}

/// Alternative implementation using OneSignal.
///
/// Requires OneSignal app ID from https://onesignal.com/
/// Configure in native Android/iOS projects per OneSignal docs.
class OneSignalNotificationService implements PushNotificationService {
  final SessionRepository _sessionRepository;

  OneSignalNotificationService(this._sessionRepository);

  /// Initializes OneSignal and captures subscription ID (token equivalent).
  @override
  Future<void> initialize() async {
    // Note: Actual OneSignal initialization would go here
    // once onesignal_flutter is added to pubspec.yaml
    //
    // Example implementation (when onesignal_flutter is available):
    //
    // OneSignal.initialize("YOUR_ONESIGNAL_APP_ID");
    // final subscriptionId = OneSignal.User.pushSubscription.id;
    // await _storeToken(subscriptionId);

    _logDebug('OneSignal service initialized');
  }

  /// Gets the currently stored subscription ID.
  @override
  Future<String?> getToken() async {
    final result = await _sessionRepository.getDeviceToken();
    return result.isSuccess ? (result as dynamic).data as String? : null;
  }

  /// Refreshes the subscription ID from OneSignal.
  @override
  Future<void> refreshToken() async {
    // Example for when onesignal_flutter is available:
    //
    // final subscriptionId = OneSignal.User.pushSubscription.id;
    // await _storeToken(subscriptionId);

    _logDebug('OneSignal subscription refresh triggered');
  }

  /// Clears the stored subscription ID on logout.
  @override
  Future<void> clearToken() async {
    final currentToken = await getToken();
    if (currentToken != null) {
      await _sessionRepository.saveDeviceToken('');
      _logDebug('OneSignal subscription cleared');
    }
  }

  /// Stores the subscription ID and platform in SessionRepository.
  ///
  /// Called automatically when OneSignal subscription ID is updated.
  /// Currently a placeholder - will be wired when onesignal_flutter is added.
  // ignore: unused_element
  Future<void> _storeToken(String? token) async {
    if (token == null || token.isEmpty) return;

    final result = await _sessionRepository.saveDeviceToken(token);
    result.when(
      success: (_) {
        _logDebug('OneSignal subscription stored: $token');
        _storePlatformInfo();
      },
      failure: (failure) {
        _logDebug('Failed to store OneSignal subscription: ${failure.message}');
      },
    );
  }

  /// Stores the device platform.
  Future<void> _storePlatformInfo() async {
    final platform = Platform.isAndroid
        ? 'android'
        : Platform.isIOS
        ? 'ios'
        : 'unknown';
    await _sessionRepository.saveDevicePlatform(platform);
    _logDebug('Device platform stored: $platform');
  }

  void _logDebug(String message) {
    if (kDebugMode) {
      print('[OneSignalNotificationService] $message');
    }
  }
}
