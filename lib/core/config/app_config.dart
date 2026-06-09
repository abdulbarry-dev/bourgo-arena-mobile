import 'dart:io' as io;
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Centralized configuration for environment variables and platform-specific checks.
class AppConfig {
  /// The base URL for the API.
  /// Configured via --dart-define=BASE_URL=...
  static const String _rawBaseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.1.47:8000/api/v1/',
  );

  /// The base URL for the API.
  static String get baseUrl => _rawBaseUrl;

  /// The timeout for API requests in milliseconds.
  /// Configured via --dart-define=API_TIMEOUT=...
  static const int apiTimeout = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30000,
  );

  /// The name of the application.
  /// Configured via --dart-define=APP_NAME=...
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Bourgo Arena',
  );

  /// The version of the application.
  /// Configured via --dart-define=APP_VERSION=...
  static const String appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );

  /// Internal flag for test environment (true/false).
  static const bool isTestEnvironment = bool.fromEnvironment(
    'IS_TEST_ENVIRONMENT',
    defaultValue: false,
  );

  /// Firebase API Key.
  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
  );

  /// Firebase App ID.
  static const String firebaseAppId = String.fromEnvironment('FIREBASE_APP_ID');

  /// Firebase Messaging Sender ID.
  static const String firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );

  /// Firebase Project ID.
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );

  static bool? _isTest;

  /// Returns true if the application is running in a test environment.
  /// Safely handles Flutter Web by avoiding dart:io calls where unsupported.
  static bool get isTest {
    if (_isTest != null) {
      return _isTest!;
    }

    if (kIsWeb) {
      _isTest = isTestEnvironment;
    } else {
      try {
        _isTest =
            isTestEnvironment ||
            io.Platform.environment.containsKey('FLUTTER_TEST');
      } catch (_) {
        // Fallback if Platform.environment throws unexpectedly
        _isTest = isTestEnvironment;
      }
    }

    return _isTest!;
  }

  /// Override the test mode manually (useful for tests).
  static void setTestMode(bool value) {
    _isTest = value;
  }
}
