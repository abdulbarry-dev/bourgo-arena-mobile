import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/is_language_selected_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late MockSessionRepository repository;
  late IsLanguageSelectedUseCase useCase;

  setUp(() {
    repository = MockSessionRepository();
    useCase = IsLanguageSelectedUseCase(repository);
  });

  group('IsLanguageSelectedUseCase', () {
    test('returns true when language has been selected', () async {
      when(
        () => repository.isLanguageSelected(),
      ).thenAnswer((_) async => const Success<bool, Failure>(true));

      final result = await useCase();

      expect(result, isA<Success<bool, Failure>>());
      expect((result as Success<bool, Failure>).data, isTrue);
      verify(() => repository.isLanguageSelected()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = CacheFailure('language state missing');

      when(
        () => repository.isLanguageSelected(),
      ).thenAnswer((_) async => const FailureResult<bool, Failure>(failure));

      final result = await useCase();

      expect(result, isA<FailureResult<bool, Failure>>());
      expect((result as FailureResult<bool, Failure>).failure, same(failure));
      verify(() => repository.isLanguageSelected()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns false unchanged as the boundary value', () async {
      when(
        () => repository.isLanguageSelected(),
      ).thenAnswer((_) async => const Success<bool, Failure>(false));

      final result = await useCase();

      expect(result, isA<Success<bool, Failure>>());
      expect((result as Success<bool, Failure>).data, isFalse);
      verify(() => repository.isLanguageSelected()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
