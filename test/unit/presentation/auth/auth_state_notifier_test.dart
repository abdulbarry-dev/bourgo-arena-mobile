import 'dart:async';
import 'package:bourgo_arena_mobile/core/utils/device_token_registrar.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checks/checks.dart';
import '../../../test_utils.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockDeviceTokenRegistrar extends Mock implements DeviceTokenRegistrar {}

void main() {
  late AuthStateNotifier notifier;
  late MockAuthRepository mockAuthRepository;
  late MockDeviceTokenRegistrar mockDeviceTokenRegistrar;
  late StreamController<User?> authStreamController;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockDeviceTokenRegistrar = MockDeviceTokenRegistrar();
    authStreamController = StreamController<User?>();

    when(
      () => mockAuthRepository.onAuthStateChanged,
    ).thenAnswer((_) => authStreamController.stream);

    when(
      () => mockDeviceTokenRegistrar.registerIfPossible(),
    ).thenAnswer((_) async {});

    notifier = AuthStateNotifier(mockAuthRepository, mockDeviceTokenRegistrar);
  });

  tearDown(() {
    authStreamController.close();
    notifier.dispose();
  });

  group('AuthStateNotifier', () {
    test('initial state has no user', () {
      check(notifier.currentUser).isNull();
      check(notifier.isAuthenticated).isFalse();
    });

    test('updates user when stream emits new user', () async {
      final user = createTestUser(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
      );

      authStreamController.add(user);

      // Wait for stream event
      await Future.delayed(Duration.zero);

      check(notifier.currentUser).equals(user);
      check(notifier.isAuthenticated).isTrue();
      verify(() => mockDeviceTokenRegistrar.registerIfPossible()).called(1);
    });

    test('updates state to unauthenticated when stream emits null', () async {
      authStreamController.add(null);

      await Future.delayed(Duration.zero);

      check(notifier.currentUser).isNull();
      check(notifier.isAuthenticated).isFalse();
    });

    test('notifies listeners on change', () async {
      int notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      authStreamController.add(null);
      await Future.delayed(Duration.zero);

      check(notifyCount).equals(1);
    });
  });
}
