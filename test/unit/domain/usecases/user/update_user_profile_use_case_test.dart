import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../usecase_test_fixtures.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository repository;
  late UpdateUserProfileUseCase useCase;

  setUp(() {
    registerFallbackValue(testUser());
    repository = MockUserRepository();
    useCase = UpdateUserProfileUseCase(repository);
  });

  group('UpdateUserProfileUseCase', () {
    test('returns the updated user on success', () async {
      final user = testUser(firstName: 'Jamie');
      when(
        () => repository.updateUserProfile(user),
      ).thenAnswer((_) async => Success<User, Failure>(user));

      final result = await useCase(user);

      expect(result, isA<Success<User, Failure>>());
      expect((result as Success<User, Failure>).data, same(user));
      verify(() => repository.updateUserProfile(user)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      final user = testUser(firstName: 'Jamie');
      const failure = ValidationFailure('update rejected');

      when(
        () => repository.updateUserProfile(user),
      ).thenAnswer((_) async => const FailureResult<User, Failure>(failure));

      final result = await useCase(user);

      expect(result, isA<FailureResult<User, Failure>>());
      expect((result as FailureResult<User, Failure>).failure, same(failure));
      verify(() => repository.updateUserProfile(user)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('forwards parent-account users unchanged', () async {
      final user = testUser(isParentAccount: true, children: const []);
      when(
        () => repository.updateUserProfile(user),
      ).thenAnswer((_) async => Success<User, Failure>(user));

      final result = await useCase(user);

      expect(result, isA<Success<User, Failure>>());
      expect((result as Success<User, Failure>).data.isParentAccount, isTrue);
      verify(() => repository.updateUserProfile(user)).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
