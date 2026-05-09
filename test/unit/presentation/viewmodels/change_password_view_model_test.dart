import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/presentation/profile/change_password_view_model.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/update_password_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUpdatePasswordUseCase extends Mock implements UpdatePasswordUseCase {}

void main() {
  late MockUpdatePasswordUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockUpdatePasswordUseCase();
  });

  test('changePassword success returns true and toggles isSaving', () async {
    when(
      () => mockUseCase(
        currentPassword: any(named: 'currentPassword'),
        newPassword: any(named: 'newPassword'),
      ),
    ).thenAnswer((_) async => Result.success(null));

    final vm = ChangePasswordViewModel(updatePasswordUseCase: mockUseCase);

    final res = await vm.changePassword(
      currentPassword: 'old',
      newPassword: 'new',
    );

    expect(res, isTrue);
    expect(vm.isSaving, isFalse);
  });

  test('changePassword failure returns false', () async {
    when(
      () => mockUseCase(
        currentPassword: any(named: 'currentPassword'),
        newPassword: any(named: 'newPassword'),
      ),
    ).thenAnswer((_) async => FailureResult(const ServerFailure('err')));

    final vm = ChangePasswordViewModel(updatePasswordUseCase: mockUseCase);

    final res = await vm.changePassword(
      currentPassword: 'old',
      newPassword: 'new',
    );

    expect(res, isFalse);
    expect(vm.isSaving, isFalse);
  });

  test('changePassword handles exception and returns false', () async {
    when(
      () => mockUseCase(
        currentPassword: any(named: 'currentPassword'),
        newPassword: any(named: 'newPassword'),
      ),
    ).thenThrow(Exception('boom'));

    final vm = ChangePasswordViewModel(updatePasswordUseCase: mockUseCase);

    final res = await vm.changePassword(
      currentPassword: 'old',
      newPassword: 'new',
    );

    expect(res, isFalse);
  });
}
