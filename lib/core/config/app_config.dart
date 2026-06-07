import 'dart:io' as io;
import 'package:flutter/foundation.dart';

/// Centralized configuration for environment variables and platform-specific checks.
class AppConfig {
  static bool? _isTest;

  /// Returns true if the application is running in a test environment.
  /// Safely handles Flutter Web by avoiding dart:io calls where unsupported.
  static bool get isTest {
    if (_isTest != null) {
      return _isTest!;
    }

    if (kIsWeb) {
      _isTest = false;
    } else {
      try {
        _isTest = io.Platform.environment.containsKey('FLUTTER_TEST');
      } catch (_) {
        // Fallback if Platform.environment throws unexpectedly
        _isTest = false;
      }
    }

    return _isTest!;
  }

  /// Override the test mode manually (useful for tests).
  static void setTestMode(bool value) {
    _isTest = value;
  }
}
