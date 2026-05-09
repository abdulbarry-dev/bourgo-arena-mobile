import 'package:bourgo_arena_mobile/core/utils/result.dart';
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
  });
}
