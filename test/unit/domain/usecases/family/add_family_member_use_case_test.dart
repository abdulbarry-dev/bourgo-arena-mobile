import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/family_member_profile.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/add_family_member_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockFamilyRepository extends Mock implements FamilyRepository {}

void main() {
  late MockFamilyRepository repository;
  late AddFamilyMemberUseCase useCase;

  setUp(() {
    repository = MockFamilyRepository();
    useCase = AddFamilyMemberUseCase(repository);
  });

  test('calls repository.addFamilyMember and returns the result', () async {
    final tProfile = FamilyMemberProfile(
      id: '20',
      name: 'Sara Ben Ali',
      relation: 'spouse',
      birthDate: DateTime(1997, 8, 22),
      createdAt: DateTime(2026, 2, 10),
    );

    when(
      () => repository.addFamilyMember(
        name: any(named: 'name'),
        relation: any(named: 'relation'),
        birthDate: any(named: 'birthDate'),
      ),
    ).thenAnswer((_) async => Success(tProfile));

    final result = await useCase(
      name: 'Sara Ben Ali',
      relation: 'spouse',
      birthDate: DateTime(1997, 8, 22),
    );

    expect(result, isA<Success<FamilyMemberProfile, Failure>>());
    expect((result as Success).data.name, 'Sara Ben Ali');
  });

  test('propagates repository failures', () async {
    when(
      () => repository.addFamilyMember(
        name: any(named: 'name'),
        relation: any(named: 'relation'),
        birthDate: any(named: 'birthDate'),
      ),
    ).thenAnswer(
      (_) async => FailureResult(
        ServerFailure(AppErrorCode.serverError, 'Server error'),
      ),
    );

    final result = await useCase(
      name: 'Sara Ben Ali',
      relation: 'spouse',
      birthDate: DateTime(1997, 8, 22),
    );

    expect(result, isA<FailureResult<FamilyMemberProfile, Failure>>());
  });
}
