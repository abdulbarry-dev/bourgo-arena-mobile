import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/profile/edit_profile_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGetUser extends Mock implements GetUserProfileUseCase {}

class MockUpdateUser extends Mock implements UpdateUserProfileUseCase {}

class UserFake extends Fake implements User {}

void main() {
  late MockGetUser mockGet;
  late MockUpdateUser mockUpdate;

  final tUser = User(
    id: 'u1',
    firstName: 'F',
    lastName: 'L',
    email: 'a@b.com',
    phone: '123',
    avatarUrl: '',
    loyaltyPoints: 0,
    subscriptionLevel: '',
    subscriptionExpiry: '',
    totalCheckIns: 0,
  );

  setUpAll(() {
    registerFallbackValue(UserFake());
  });

  setUp(() {
    mockGet = MockGetUser();
    mockUpdate = MockUpdateUser();
    when(() => mockGet()).thenAnswer((_) async => Result.success(tUser));
    when(
      () => mockUpdate(any()),
    ).thenAnswer((_) async => Result.success(tUser));
  });

  test('loads existing profile on init', () async {
    final vm = EditProfileViewModel(
      getUserProfileUseCase: mockGet,
      updateUserProfileUseCase: mockUpdate,
    );
    await Future.delayed(Duration.zero);
    expect(vm.isLoading, isFalse);
    expect(vm.user, isNotNull);
  });

  test('saveProfile calls update and returns true on success', () async {
    final vm = EditProfileViewModel(
      getUserProfileUseCase: mockGet,
      updateUserProfileUseCase: mockUpdate,
    );
    await Future.delayed(Duration.zero);
    final ok = await vm.saveProfile(
      firstName: 'X',
      lastName: 'Y',
      email: 'x@y.com',
      phone: '9',
    );
    expect(ok, isTrue);
    verify(() => mockUpdate(any())).called(1);
  });

  test('saveProfile returns false when update fails', () async {
    when(
      () => mockUpdate(any()),
    ).thenAnswer((_) async => FailureResult(const ServerFailure('err')));
    final vm = EditProfileViewModel(
      getUserProfileUseCase: mockGet,
      updateUserProfileUseCase: mockUpdate,
    );
    await Future.delayed(Duration.zero);
    final ok = await vm.saveProfile(
      firstName: 'X',
      lastName: 'Y',
      email: 'x@y.com',
      phone: '9',
    );
    expect(ok, isFalse);
  });
}
