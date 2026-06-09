import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/device_registration_data.dart';

abstract interface class DeviceRegistrationRepository {
  Future<Result<DeviceRegistrationData, Failure>> register({
    required String deviceId,
    required String platform,
    required String appVersion,
    Map<String, dynamic>? fingerprint,
    String? integrityToken,
  });

  Future<Result<DeviceRefreshData, Failure>> refresh();

  Future<Result<void, Failure>> link(String deviceId);

  Future<Result<void, Failure>> logout(String deviceId);
}
