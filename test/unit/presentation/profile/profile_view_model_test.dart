import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_view_model.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

class MockUpdateUserProfileUseCase extends Mock
    implements UpdateUserProfileUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class FakeUser extends Fake implements User {}

void main() {
  late ProfileViewModel viewModel;
  late MockGetUserProfileUseCase mockGetUserProfileUseCase;
  late MockUpdateUserProfileUseCase mockUpdateUserProfileUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

  final testUser = User(
    id: 'user-1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    phone: '123456789',
    avatarUrl: 'https://example.com/avatar.png',
    loyaltyPoints: 100,
    subscriptionLevel: 'Gold',
    subscriptionExpiry: '2026-12-31',
    totalCheckIns: 42,
    children: [
      ChildProfile(
        id: 'child-1',
        firstName: 'Jane',
        lastName: 'Doe',
        birthDate: DateTime(2015, 1, 1),
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(FakeUser());
  });

  setUp(() {
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    mockUpdateUserProfileUseCase = MockUpdateUserProfileUseCase();
    mockLogoutUseCase = MockLogoutUseCase();

    // Default behavior for constructor's loadProfile call
    when(
      () => mockGetUserProfileUseCase(),
    ).thenAnswer((_) async => Result.success(testUser));

    viewModel = ProfileViewModel(
      getUserProfileUseCase: mockGetUserProfileUseCase,
      updateUserProfileUseCase: mockUpdateUserProfileUseCase,
      logoutUseCase: mockLogoutUseCase,
    );
  });

  group('ProfileViewModel', () {
    test('initial state sets loading then success with user data', () async {
      // ViewModel calls loadProfile in constructor
      check(viewModel.isLoading).isFalse();
      check(viewModel.user).isNotNull().equals(testUser);
      check(viewModel.user?.children.length).equals(1);
      check(viewModel.errorMessage).isNull();
    });

    test('loadProfile sets failure state on error', () async {
      when(() => mockGetUserProfileUseCase()).thenAnswer(
        (_) async => Result.failure(const ServerFailure('Server error')),
      );

      await viewModel.loadProfile();

      check(viewModel.isLoading).isFalse();
      check(viewModel.errorMessage).isNotNull().equals('Server error');
    });

    test('updateProfile success updates user data', () async {
      final updatedUser = testUser.copyWith(firstName: 'Johnny');
      when(
        () => mockUpdateUserProfileUseCase(any()),
      ).thenAnswer((_) async => Result.success(updatedUser));

      final result = await viewModel.updateProfile(updatedUser);

      check(result.isSuccess).isTrue();
      check(viewModel.user).equals(updatedUser);
      check(viewModel.errorMessage).isNull();
      verify(() => mockUpdateUserProfileUseCase(updatedUser)).called(1);
    });

    test('updateProfile failure sets error message', () async {
      when(() => mockUpdateUserProfileUseCase(any())).thenAnswer(
        (_) async => Result.failure(const ServerFailure('Update failed')),
      );

      final result = await viewModel.updateProfile(testUser);

      check(result.isFailure).isTrue();
      check(viewModel.errorMessage).isNotNull().equals('Update failed');
    });

    test('logout calls LogoutUseCase', () async {
      when(
        () => mockLogoutUseCase(),
      ).thenAnswer((_) async => Result.success(null));

      await viewModel.logout();

      verify(() => mockLogoutUseCase()).called(1);
    });
  });
}
