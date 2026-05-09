import 'dart:async';

import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late StreamController<User?> controller;

  setUp(() {
    mockRepo = MockAuthRepository();
    controller = StreamController<User?>.broadcast();
    when(
      () => mockRepo.onAuthStateChanged,
    ).thenAnswer((_) => controller.stream);
  });

  tearDown(() async {
    await controller.close();
  });

  test(
    'unauthenticated initial state and then authenticated after emission',
    () async {
      final notifier = AuthStateNotifier(mockRepo);
      expect(notifier.isAuthenticated, isFalse);

      final user = User(
        id: 'u1',
        firstName: 'F',
        lastName: 'L',
        email: 'a@b.com',
        phone: '1',
        avatarUrl: '',
        loyaltyPoints: 0,
        subscriptionLevel: '',
        subscriptionExpiry: '',
        totalCheckIns: 0,
      );

      controller.add(user);
      // allow async listener to process
      await Future.delayed(Duration.zero);

      expect(notifier.isAuthenticated, isTrue);
      expect(notifier.currentUser, isNotNull);

      controller.add(null);
      await Future.delayed(Duration.zero);
      expect(notifier.isAuthenticated, isFalse);
      notifier.dispose();
    },
  );
}
