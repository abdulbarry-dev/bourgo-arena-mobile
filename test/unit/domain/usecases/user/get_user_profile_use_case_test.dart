import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../usecase_test_fixtures.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository repository;
  late GetUserProfileUseCase useCase;

  setUp(() {
    registerFallbackValue(testUser());
    repository = MockUserRepository();
    useCase = GetUserProfileUseCase(repository);
  });

  group('GetUserProfileUseCase', () {
    test('returns the user profile on success', () async {
      final user = testUser();
      when(
        () => repository.getUserProfile(),
      ).thenAnswer((_) async => Success<User, Failure>(user));

      final result = await useCase();

      expect(result, isA<Success<User, Failure>>());
      expect((result as Success<User, Failure>).data, same(user));
      verify(() => repository.getUserProfile()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = NotFoundFailure('profile missing');

      when(
        () => repository.getUserProfile(),
      ).thenAnswer((_) async => const FailureResult<User, Failure>(failure));

      final result = await useCase();

      expect(result, isA<FailureResult<User, Failure>>());
      expect((result as FailureResult<User, Failure>).failure, same(failure));
      verify(() => repository.getUserProfile()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns users with empty children lists unchanged', () async {
      final user = testUser(children: const [], isParentAccount: true);
      when(
        () => repository.getUserProfile(),
      ).thenAnswer((_) async => Success<User, Failure>(user));

      final result = await useCase();

      expect(result, isA<Success<User, Failure>>());
      expect((result as Success<User, Failure>).data.children, isEmpty);
      verify(() => repository.getUserProfile()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
