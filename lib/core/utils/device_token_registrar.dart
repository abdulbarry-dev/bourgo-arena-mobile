import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/device/register_device_token_use_case.dart';

/// Coordinates device token registration when prerequisites are met.
class DeviceTokenRegistrar {
  final SessionRepository _sessionRepository;
  final RegisterDeviceTokenUseCase _registerDeviceTokenUseCase;

  DeviceTokenRegistrar(
    this._sessionRepository,
    this._registerDeviceTokenUseCase,
  );

  /// Attempts to register the stored device token if available.
  Future<void> registerIfPossible({
    bool requireNotificationsEnabled = true,
  }) async {
    if (requireNotificationsEnabled) {
      final notificationResult = await _sessionRepository
          .areNotificationsEnabled();
      final enabled = notificationResult.isSuccess
          ? (notificationResult as Success<bool, dynamic>).data
          : false;
      if (!enabled) {
        return;
      }
    }

    try {
      // Request permission for iOS/Web (Android doesn't strictly need this for token, but good practice)
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        return;
      }

      final token = await messaging.getToken();
      if (token == null || token.isEmpty) {
        return;
      }

      await _sessionRepository.saveDeviceToken(token);

      String platform = 'web';
      if (!kIsWeb) {
        if (Platform.isAndroid) {
          platform = 'android';
        } else if (Platform.isIOS) {
          platform = 'ios';
        } else {
          platform = Platform.operatingSystem;
        }
      }

      await _sessionRepository.saveDevicePlatform(platform);

      await _registerDeviceTokenUseCase.execute(token, platform);

      // Listen to token refreshes
      messaging.onTokenRefresh.listen((newToken) async {
        await _sessionRepository.saveDeviceToken(newToken);
        await _registerDeviceTokenUseCase.execute(newToken, platform);
      });
    } catch (e) {
      // Ignore FCM initialization errors if Firebase is not properly configured yet
    }
  }

  /// Unregisters the device from receiving push notifications by deleting the token.
  Future<void> unregister() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      // Optional: you could also clear the locally saved token
      // await _sessionRepository.saveDeviceToken('');
    } catch (e) {
      // Ignore errors if Firebase is not configured or network fails
    }
  }
}
