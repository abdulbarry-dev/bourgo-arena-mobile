import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

class MockUpdateUserProfileUseCase extends Mock
    implements UpdateUserProfileUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class UserFake extends Fake implements User {}

void _registerFallbacks() {
  registerFallbackValue(UserFake());
}

void main() {
  late MockGetUserProfileUseCase mockGet;
  late MockUpdateUserProfileUseCase mockUpdate;
  late MockLogoutUseCase mockLogout;

  final tUser = User(
    id: 'u1',
    firstName: 'Test',
    lastName: 'User',
    email: 'test@example.com',
    phone: '123',
    avatarUrl: '',
    loyaltyPoints: 0,
    subscriptionLevel: '',
    subscriptionExpiry: '',
    totalCheckIns: 0,
  );

  setUpAll(_registerFallbacks);

  setUp(() {
    mockGet = MockGetUserProfileUseCase();
    mockUpdate = MockUpdateUserProfileUseCase();
    mockLogout = MockLogoutUseCase();

    when(() => mockGet()).thenAnswer((_) async => Result.success(tUser));
    when(
      () => mockUpdate(any()),
    ).thenAnswer((_) async => Result.success(tUser));
    when(() => mockLogout()).thenAnswer((_) async => Result.success(null));
  });

  test('loading state and successful profile load', () async {
    final vm = ProfileViewModel(
      getUserProfileUseCase: mockGet,
      updateUserProfileUseCase: mockUpdate,
      logoutUseCase: mockLogout,
    );

    // constructor triggers loadProfile()
    expect(vm.isLoading, isTrue);
    await Future.delayed(Duration.zero);

    expect(vm.isLoading, isFalse);
    expect(vm.user, isNotNull);
    expect(vm.user?.email, 'test@example.com');
    verify(() => mockGet()).called(1);
  });

  test('failure sets error message', () async {
    when(
      () => mockGet(),
    ).thenAnswer((_) async => FailureResult(const ServerFailure('bad')));

    final vm = ProfileViewModel(
      getUserProfileUseCase: mockGet,
      updateUserProfileUseCase: mockUpdate,
      logoutUseCase: mockLogout,
    );

    await Future.delayed(Duration.zero);

    expect(vm.errorMessage, 'bad');
  });

  test('updateProfile success updates user and clears loading', () async {
    final vm = ProfileViewModel(
      getUserProfileUseCase: mockGet,
      updateUserProfileUseCase: mockUpdate,
      logoutUseCase: mockLogout,
    );

    await Future.delayed(Duration.zero);

    final res = await vm.updateProfile(tUser);

    expect(res.isSuccess, isTrue);
    expect(vm.user?.name, 'Test User');
    expect(vm.isLoading, isFalse);
    verify(() => mockUpdate(tUser)).called(1);
  });

  test('updateProfile failure sets error message', () async {
    when(
      () => mockUpdate(any()),
    ).thenAnswer((_) async => FailureResult(const ServerFailure('upd')));

    final vm = ProfileViewModel(
      getUserProfileUseCase: mockGet,
      updateUserProfileUseCase: mockUpdate,
      logoutUseCase: mockLogout,
    );

    await Future.delayed(Duration.zero);

    final res = await vm.updateProfile(tUser);

    expect(res.isFailure, isTrue);
    expect(vm.errorMessage, 'upd');
  });

  test('logout calls LogoutUseCase', () async {
    final vm = ProfileViewModel(
      getUserProfileUseCase: mockGet,
      updateUserProfileUseCase: mockUpdate,
      logoutUseCase: mockLogout,
    );

    await Future.delayed(Duration.zero);

    await vm.logout();

    verify(() => mockLogout()).called(1);
  });
}
