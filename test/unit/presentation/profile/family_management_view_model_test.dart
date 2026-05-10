import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import '../../data/repositories/repository_test_fixtures.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/request_family_account_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/profile/family_management_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checks/checks.dart';

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

class MockUpdateUserProfileUseCase extends Mock
    implements UpdateUserProfileUseCase {}

class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

class MockRequestFamilyAccountOtpUseCase extends Mock
    implements RequestFamilyAccountOtpUseCase {}

void main() {
  late FamilyManagementViewModel viewModel;
  late MockGetUserProfileUseCase mockGetUserProfileUseCase;
  late MockUpdateUserProfileUseCase mockUpdateUserProfileUseCase;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockRequestFamilyAccountOtpUseCase mockRequestFamilyAccountOtpUseCase;

  final testUser = testUserEntity(id: '1');

  setUp(() {
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    mockUpdateUserProfileUseCase = MockUpdateUserProfileUseCase();
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockRequestFamilyAccountOtpUseCase = MockRequestFamilyAccountOtpUseCase();

    when(
      () => mockGetUserProfileUseCase(),
    ).thenAnswer((_) async => Result.success(testUser));
    registerFallbackValue(testUser);

    viewModel = FamilyManagementViewModel(
      getUserProfileUseCase: mockGetUserProfileUseCase,
      updateUserProfileUseCase: mockUpdateUserProfileUseCase,
      verifyOtpUseCase: mockVerifyOtpUseCase,
      requestFamilyAccountOtpUseCase: mockRequestFamilyAccountOtpUseCase,
    );
  });

  group('FamilyManagementViewModel', () {
    test('initial load', () async {
      await Future.delayed(Duration.zero);
      check(viewModel.user).equals(testUser);
      check(viewModel.isLoading).isFalse();
    });

    test('requestFamilyAccountOtp success', () async {
      await Future.delayed(Duration.zero);
      when(
        () => mockRequestFamilyAccountOtpUseCase(),
      ).thenAnswer((_) async => Result.success(null));

      final result = await viewModel.requestFamilyAccountOtp();

      check(result).isTrue();
      check(viewModel.isOtpSent).isTrue();
    });

    test('verifyFamilyAccountOtp success', () async {
      await Future.delayed(Duration.zero);
      when(
        () => mockVerifyOtpUseCase(any(), any()),
      ).thenAnswer((_) async => Result.success(true));
      when(() => mockUpdateUserProfileUseCase(any())).thenAnswer(
        (_) async => Result.success(testUser.copyWith(isParentAccount: true)),
      );

      final result = await viewModel.verifyFamilyAccountOtp('123456');

      check(result).isTrue();
      check(
        viewModel.user,
      ).isNotNull().has((u) => u.isParentAccount, 'isParentAccount').isTrue();
      check(viewModel.isOtpSent).isFalse();
    });

    test('addChildFromForm validation', () async {
      await Future.delayed(Duration.zero);

      final result = await viewModel.addChildFromForm();

      check(result).isFalse();
      check(viewModel.hasChildFirstNameError).isTrue();
      check(viewModel.hasChildLastNameError).isTrue();
      check(viewModel.hasChildBirthDateError).isTrue();
      check(viewModel.hasChildGenderError).isTrue();
    });

    test('addChildFromForm success', () async {
      await Future.delayed(Duration.zero);

      viewModel.childFirstNameController.text = 'Junior';
      viewModel.childLastNameController.text = 'Doe';
      viewModel.setChildGender('Male');
      viewModel.setChildBirthDate(DateTime(2015));

      final updatedUser = testUser.copyWith(
        isParentAccount: true,
        children: [],
      ); // simplified
      when(
        () => mockUpdateUserProfileUseCase(any()),
      ).thenAnswer((_) async => Result.success(updatedUser));

      final result = await viewModel.addChildFromForm();

      check(result).isTrue();
      check(viewModel.childFirstNameController.text).equals(''); // cleared
    });

    test(
      'requestFamilyAccountOtp failure sets error message and does not change OTP state',
      () async {
        when(
          () => mockRequestFamilyAccountOtpUseCase(),
        ).thenAnswer((_) async => Result.failure(AuthFailure('OTP failed')));

        final result = await viewModel.requestFamilyAccountOtp();

        check(result).isFalse();
        check(viewModel.errorMessage).equals('OTP failed');
        check(viewModel.isOtpSent).isFalse();
      },
    );

    test(
      'verifyFamilyAccountOtp failure sets error message and does not proceed',
      () async {
        when(
          () => mockVerifyOtpUseCase(any(), any()),
        ).thenAnswer((_) async => Result.failure(AuthFailure('Verify failed')));

        final initialIsParent = viewModel.user?.isParentAccount;
        final result = await viewModel.verifyFamilyAccountOtp('123456');

        check(result).isFalse();
        check(viewModel.errorMessage).equals('Verify failed');
        check(viewModel.user?.isParentAccount).equals(initialIsParent);
      },
    );

    test(
      'addChildFromForm failure sets error message and does not add to list',
      () async {
        when(() => mockUpdateUserProfileUseCase(any())).thenAnswer(
          (_) async => Result.failure(ServerFailure('Add child failed')),
        );

        viewModel.childFirstNameController.text = 'Junior';
        viewModel.childLastNameController.text = 'Doe';
        viewModel.setChildGender('male');
        viewModel.setChildBirthDate(DateTime(2020, 1, 1));

        final initialCount = viewModel.user?.children.length ?? 0;
        final result = await viewModel.addChildFromForm();

        check(result).isFalse();
        check(viewModel.errorMessage).equals('Add child failed');
        check(viewModel.user?.children.length).equals(initialCount);
      },
    );

    test('removeChild success removes member from list', () async {
      final child = testChildEntity(id: 'child-1');
      final userWithChild = testUserEntity(children: [child]);
      when(
        () => mockGetUserProfileUseCase(),
      ).thenAnswer((_) async => Result.success(userWithChild));

      viewModel = FamilyManagementViewModel(
        getUserProfileUseCase: mockGetUserProfileUseCase,
        updateUserProfileUseCase: mockUpdateUserProfileUseCase,
        verifyOtpUseCase: mockVerifyOtpUseCase,
        requestFamilyAccountOtpUseCase: mockRequestFamilyAccountOtpUseCase,
      );
      await Future.delayed(Duration.zero);

      when(() => mockUpdateUserProfileUseCase(any())).thenAnswer(
        (_) async => Result.success(userWithChild.copyWith(children: [])),
      );

      viewModel.setErrorMessage('old error');
      final result = await viewModel.removeChild('child-1');

      check(result).isTrue();
      check(viewModel.user?.children.length).equals(0);
      check(viewModel.errorMessage).isNull();
    });

    test('removeChild failure sets error and list unchanged', () async {
      final child = testChildEntity(id: 'child-1');
      final userWithChild = testUserEntity(children: [child]);
      when(
        () => mockGetUserProfileUseCase(),
      ).thenAnswer((_) async => Result.success(userWithChild));

      viewModel = FamilyManagementViewModel(
        getUserProfileUseCase: mockGetUserProfileUseCase,
        updateUserProfileUseCase: mockUpdateUserProfileUseCase,
        verifyOtpUseCase: mockVerifyOtpUseCase,
        requestFamilyAccountOtpUseCase: mockRequestFamilyAccountOtpUseCase,
      );
      await Future.delayed(Duration.zero);

      when(
        () => mockUpdateUserProfileUseCase(any()),
      ).thenAnswer((_) async => Result.failure(ServerFailure('Remove failed')));

      final result = await viewModel.removeChild('child-1');

      check(result).isFalse();
      check(viewModel.errorMessage).equals('Remove failed');
      check(viewModel.user?.children.length).equals(1);
    });
  });
}
