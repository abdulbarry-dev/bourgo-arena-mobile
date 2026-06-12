import 'dart:developer' as developer;
import 'package:bourgo_arena_mobile/core/utils/device_identity_provider.dart';
import 'package:bourgo_arena_mobile/core/utils/device_identity_storage.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/domain/repositories/device_registration_repository.dart';

class DeviceIdentityService {
  final DeviceIdentityProvider _provider;
  final DeviceIdentityStorage _storage;
  final DeviceRegistrationRepository _registrationRepo;
  final ApiClient _apiClient;

  DeviceIdentityService(
    this._provider,
    this._storage,
    this._registrationRepo,
    this._apiClient,
  );

  Future<void> initialize() async {
    var deviceId = _storage.getDeviceId();
    if (deviceId == null) {
      deviceId = _provider.generateDeviceId();
      await _storage.saveDeviceId(deviceId);
      developer.log(
        'Generated new Device ID: $deviceId',
        name: 'DeviceIdentityService',
      );
    }

    final existingToken = _storage.getRegistrationToken();
    if (existingToken == null) {
      developer.log(
        'No device token found, registering device...',
        name: 'DeviceIdentityService',
      );
      await _registerDevice(deviceId);
    } else if (_storage.needsTokenRefresh()) {
      developer.log(
        'Device token needs refresh, refreshing...',
        name: 'DeviceIdentityService',
      );
      await _refreshDeviceToken();
    }

    final token = _storage.getRegistrationToken();
    if (token != null) {
      developer.log(
        'Device token set for ApiClient',
        name: 'DeviceIdentityService',
      );
      _apiClient.setDeviceToken(token);
    } else {
      developer.log(
        'WARNING: Failed to obtain device token during initialization.',
        name: 'DeviceIdentityService',
      );
    }
  }

  Future<bool> _registerDevice(String deviceId) async {
    try {
      final appVersion = await _provider.getAppVersion();
      final platform = _provider.getPlatform();
      final fingerprint = await _provider.getDeviceFingerprint();

      final result = await _registrationRepo.register(
        deviceId: deviceId,
        platform: platform,
        appVersion: appVersion,
        fingerprint: fingerprint,
      );

      return result.when(
        success: (data) {
          _storage.saveRegistrationToken(data.token);
          _storage.saveTokenExpiresAt(data.expiresAt);
          developer.log(
            'Device registered successfully.',
            name: 'DeviceIdentityService',
          );
          return true;
        },
        failure: (failure) {
          developer.log(
            'Device registration failed: ${failure.message}',
            name: 'DeviceIdentityService',
          );
          return false;
        },
      );
    } catch (e) {
      developer.log(
        'Exception during device registration: $e',
        name: 'DeviceIdentityService',
      );
      return false;
    }
  }

  Future<void> _refreshDeviceToken() async {
    try {
      final result = await _registrationRepo.refresh();

      result.when(
        success: (data) {
          _storage.saveRegistrationToken(data.token);
          _storage.saveTokenExpiresAt(data.expiresAt);
        },
        failure: (_) {
          _storage.clearRegistrationData();
        },
      );
    } catch (_) {
      _storage.clearRegistrationData();
    }
  }
}
