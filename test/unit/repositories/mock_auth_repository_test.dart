import 'package:bourgo_arena_mobile/data/repositories/mock_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';

void main() {
  group('MockAuthRepository', () {
    late MockAuthRepository repository;

    setUp(() {
      repository = MockAuthRepository();
    });

    test('sendOtp completes for any identifier', () async {
      await repository.sendOtp('test@example.com');
      // If it completes without error, it's a pass
    });

    test('verifyOtp returns true for 4-digit OTP', () async {
      final result = await repository.verifyOtp('test@example.com', '1234');
      check(result).equals(true);
    });

    test('verifyOtp returns false for wrong length OTP', () async {
      final result = await repository.verifyOtp('test@example.com', '123');
      check(result).equals(false);
    });

    test('requestFamilyAccountOtp completes', () async {
      await repository.requestFamilyAccountOtp();
      // If it completes without error, it's a pass
    });
  });
}
