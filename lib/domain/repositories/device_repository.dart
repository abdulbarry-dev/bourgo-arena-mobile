import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';

/// Repository interface for managing device-specific settings and tokens.
abstract class DeviceRepository {
  /// Registers or updates the push notification token on the server.
  Future<Result<void, Failure>> registerDeviceToken(
    String token,
    String? platform,
  );
}
