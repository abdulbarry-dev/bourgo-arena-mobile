import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/remove_family_member_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockFamilyRepository extends Mock implements FamilyRepository {}

void main() {
  late MockFamilyRepository repository;
  late RemoveFamilyMemberUseCase useCase;

  setUp(() {
    repository = MockFamilyRepository();
    useCase = RemoveFamilyMemberUseCase(repository);
  });

  test('calls repository.removeFamilyMember and returns success', () async {
    when(
      () => repository.removeFamilyMember(any()),
    ).thenAnswer((_) async => const Success(null));

    final result = await useCase('20');

    expect(result, isA<Success<void, Failure>>());
    verify(() => repository.removeFamilyMember('20')).called(1);
  });

  test('propagates repository failures', () async {
    when(() => repository.removeFamilyMember(any())).thenAnswer(
      (_) async => FailureResult(
        const ServerFailure(AppErrorCode.serverError, 'Server error'),
      ),
    );

    final result = await useCase('20');

    expect(result, isA<FailureResult<void, Failure>>());
  });
}
