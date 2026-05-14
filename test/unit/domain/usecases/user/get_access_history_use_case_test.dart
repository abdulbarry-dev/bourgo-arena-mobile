import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/access_history_entry.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_access_history_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository repository;
  late GetAccessHistoryUseCase useCase;

  setUp(() {
    repository = MockUserRepository();
    useCase = GetAccessHistoryUseCase(repository);
  });

  group('GetAccessHistoryUseCase', () {
    test('returns access history on success', () async {
      final entries = [
        AccessHistoryEntry(
          id: 'acc_001',
          checkedInAt: DateTime.parse('2026-05-14T09:42:00Z'),
          location: 'Main Entrance',
        ),
      ];

      when(() => repository.getAccessHistory()).thenAnswer(
        (_) async => Success<List<AccessHistoryEntry>, Failure>(entries),
      );

      final result = await useCase();

      expect(result, isA<Success<List<AccessHistoryEntry>, Failure>>());
      expect(
        (result as Success<List<AccessHistoryEntry>, Failure>).data,
        same(entries),
      );
      verify(() => repository.getAccessHistory()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = ServerFailure('access history unavailable');

      when(() => repository.getAccessHistory()).thenAnswer(
        (_) async =>
            const FailureResult<List<AccessHistoryEntry>, Failure>(failure),
      );

      final result = await useCase();

      expect(result, isA<FailureResult<List<AccessHistoryEntry>, Failure>>());
      expect(
        (result as FailureResult<List<AccessHistoryEntry>, Failure>).failure,
        same(failure),
      );
      verify(() => repository.getAccessHistory()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
