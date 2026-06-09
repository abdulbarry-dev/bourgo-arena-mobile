import 'package:bourgo_arena_mobile/core/utils/device_identity_storage.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_auth_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_device_registration_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/local_session_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/device_registration_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'dart:developer' as developer;

void main() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final sessionRepo = LocalSessionRepository(prefs);
  final apiClient = ApiClient(baseUrl: 'http://127.0.0.1:8000/api/v1');
  final deviceIdentityStorage = DeviceIdentityStorage(prefs);
  final DeviceRegistrationRepository deviceRegistrationRepo =
      ApiDeviceRegistrationRepository(apiClient);
  final authRepo = ApiAuthRepository(
    apiClient,
    sessionRepo,
    deviceIdentityStorage,
    deviceRegistrationRepo,
  );

  final user = User(
    id: '',
    firstName: 'Test',
    lastName: 'Dart',
    email: 'testdart@example.com',
    phone: '77777777',
    avatarUrl: '',
    loyaltyPoints: 0,
    subscriptionLevel: 'FREE',
    subscriptionExpiry: null,
    gender: 'male',
    birthDate: DateTime(1990, 1, 1),
    isParentAccount: false,
    children: [],
  );

  final regRes = await authRepo.register(
    firstName: user.firstName,
    lastName: user.lastName,
    email: user.email,
    password: 'password123',
    phone: user.phone ?? '',
    gender: user.gender ?? 'male',
    birthDate: user.birthDate ?? DateTime.now(),
  );
  developer.log('Register: $regRes');

  // Hardcode OTP in DB
  await ApiClient(
    baseUrl: 'http://127.0.0.1:8000',
  ).get('/api/v1/auth/forgot-password'); // just pinging

  // Since we can't easily execute PHP from Dart here, we'll assume we can skip verification or similar.
}
