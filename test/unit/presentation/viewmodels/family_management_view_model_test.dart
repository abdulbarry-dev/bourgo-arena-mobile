import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/request_family_account_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/profile/family_management_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGetUser extends Mock implements GetUserProfileUseCase {}

class MockUpdateUser extends Mock implements UpdateUserProfileUseCase {}

class MockVerifyOtp extends Mock implements VerifyOtpUseCase {}

class MockRequestOtp extends Mock implements RequestFamilyAccountOtpUseCase {}

class UserFake extends Fake implements User {}

void main() {
  late MockGetUser mockGet;
  late MockUpdateUser mockUpdate;
  late MockVerifyOtp mockVerify;
  late MockRequestOtp mockRequest;

  final child = ChildProfile(
    id: 'c1',
    firstName: 'A',
    lastName: 'B',
    birthDate: DateTime(2020, 1, 1),
    gender: 'male',
  );
  final tUser = User(
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
    children: [child],
  );

  setUpAll(() {
    registerFallbackValue(UserFake());
  });

  setUp(() {
    mockGet = MockGetUser();
    mockUpdate = MockUpdateUser();
    mockVerify = MockVerifyOtp();
    mockRequest = MockRequestOtp();

    when(() => mockGet()).thenAnswer((_) async => Result.success(tUser));
    when(
      () => mockUpdate(any()),
    ).thenAnswer((_) async => Result.success(tUser));
    when(() => mockRequest()).thenAnswer((_) async => Result.success(null));
    when(
      () => mockVerify(any(), any()),
    ).thenAnswer((_) async => Result.success(true));
  });

  test('loads family list on init', () async {
    final vm = FamilyManagementViewModel(
      getUserProfileUseCase: mockGet,
      updateUserProfileUseCase: mockUpdate,
      verifyOtpUseCase: mockVerify,
      requestFamilyAccountOtpUseCase: mockRequest,
    );
    await Future.delayed(Duration.zero);
    expect(vm.user, isNotNull);
    expect(vm.user?.children.length, 1);
  });

  test('requestFamilyAccountOtp sets isOtpSent on success', () async {
    final vm = FamilyManagementViewModel(
      getUserProfileUseCase: mockGet,
      updateUserProfileUseCase: mockUpdate,
      verifyOtpUseCase: mockVerify,
      requestFamilyAccountOtpUseCase: mockRequest,
    );
    await Future.delayed(Duration.zero);
    final ok = await vm.requestFamilyAccountOtp();
    expect(ok, isTrue);
    expect(vm.isOtpSent, isTrue);
  });

  test('addChildFromForm validates and calls update', () async {
    final vm = FamilyManagementViewModel(
      getUserProfileUseCase: mockGet,
      updateUserProfileUseCase: mockUpdate,
      verifyOtpUseCase: mockVerify,
      requestFamilyAccountOtpUseCase: mockRequest,
    );
    await Future.delayed(Duration.zero);
    vm.childFirstNameController.text = 'New';
    vm.childLastNameController.text = 'Kid';
    vm.setChildBirthDate(DateTime(2019, 1, 1));
    vm.setChildGender('female');
    final ok = await vm.addChildFromForm();
    expect(ok, isTrue);
    verify(() => mockUpdate(any())).called(1);
  });
}
