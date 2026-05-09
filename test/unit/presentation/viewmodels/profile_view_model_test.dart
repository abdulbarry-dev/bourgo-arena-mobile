import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

class MockUpdateUserProfileUseCase extends Mock
    implements UpdateUserProfileUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late ProfileViewModel viewModel;
  late MockGetUserProfileUseCase mockGetUserProfileUseCase;
  late MockUpdateUserProfileUseCase mockUpdateUserProfileUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

  final tUser = User(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    phone: '123456789',
    avatarUrl: 'https://example.com/avatar.png',
    loyaltyPoints: 100,
    subscriptionLevel: 'GOLD',
    subscriptionExpiry: '2025-12-31',
    totalCheckIns: 10,
    isParentAccount: true,
    children: [
      ChildProfile(
        id: 'c1',
        firstName: 'Jane',
        lastName: 'Doe',
        birthDate: DateTime(2015, 1, 1),
      ),
    ],
  );

  setUp(() {
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    mockUpdateUserProfileUseCase = MockUpdateUserProfileUseCase();
    mockLogoutUseCase = MockLogoutUseCase();

    registerFallbackValue(tUser);

    // Default mock behavior
    when(
      () => mockGetUserProfileUseCase(),
    ).thenAnswer((_) async => Success(tUser));
  });

  group('ProfileViewModel', () {
    test('initial state loads profile and populates user', () async {
      // Act
      viewModel = ProfileViewModel(
        getUserProfileUseCase: mockGetUserProfileUseCase,
        updateUserProfileUseCase: mockUpdateUserProfileUseCase,
        logoutUseCase: mockLogoutUseCase,
      );

      // Wait for the async load in constructor
      await Future.delayed(Duration.zero);

      // Assert
      expect(viewModel.user, tUser);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.user!.children.length, 1);
      verify(() => mockGetUserProfileUseCase()).called(1);
    });

    test('loadProfile failure sets error message', () async {
      // Arrange
      const tFailure = ServerFailure('Failed to load profile');
      when(
        () => mockGetUserProfileUseCase(),
      ).thenAnswer((_) async => const FailureResult(tFailure));

      // Act
      viewModel = ProfileViewModel(
        getUserProfileUseCase: mockGetUserProfileUseCase,
        updateUserProfileUseCase: mockUpdateUserProfileUseCase,
        logoutUseCase: mockLogoutUseCase,
      );
      await Future.delayed(Duration.zero);

      // Assert
      expect(viewModel.user, isNull);
      expect(viewModel.errorMessage, 'Failed to load profile');
    });

    test('updateProfile success updates user data', () async {
      // Arrange
      final updatedUser = tUser.copyWith(firstName: 'Johnny');
      when(
        () => mockUpdateUserProfileUseCase(any()),
      ).thenAnswer((_) async => Success(updatedUser));

      viewModel = ProfileViewModel(
        getUserProfileUseCase: mockGetUserProfileUseCase,
        updateUserProfileUseCase: mockUpdateUserProfileUseCase,
        logoutUseCase: mockLogoutUseCase,
      );
      await Future.delayed(Duration.zero);

      // Act
      final result = await viewModel.updateProfile(updatedUser);

      // Assert
      expect(result.isSuccess, true);
      expect(viewModel.user!.firstName, 'Johnny');
      expect(viewModel.errorMessage, isNull);
      verify(() => mockUpdateUserProfileUseCase(updatedUser)).called(1);
    });

    test('updateProfile failure sets error message', () async {
      // Arrange
      const tFailure = ServerFailure('Update failed');
      when(
        () => mockUpdateUserProfileUseCase(any()),
      ).thenAnswer((_) async => const FailureResult(tFailure));

      viewModel = ProfileViewModel(
        getUserProfileUseCase: mockGetUserProfileUseCase,
        updateUserProfileUseCase: mockUpdateUserProfileUseCase,
        logoutUseCase: mockLogoutUseCase,
      );
      await Future.delayed(Duration.zero);

      // Act
      final result = await viewModel.updateProfile(tUser);

      // Assert
      expect(result.isFailure, true);
      expect(viewModel.errorMessage, 'Update failed');
    });

    test('logout triggers logoutUseCase', () async {
      // Arrange
      when(
        () => mockLogoutUseCase(),
      ).thenAnswer((_) async => const Success(null));

      viewModel = ProfileViewModel(
        getUserProfileUseCase: mockGetUserProfileUseCase,
        updateUserProfileUseCase: mockUpdateUserProfileUseCase,
        logoutUseCase: mockLogoutUseCase,
      );
      await Future.delayed(Duration.zero);

      // Act
      await viewModel.logout();

      // Assert
      verify(() => mockLogoutUseCase()).called(1);
    });
  });
}
