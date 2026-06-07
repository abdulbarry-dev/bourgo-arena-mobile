import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/delete_account_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_view_model.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockDeleteAccountUseCase extends Mock implements DeleteAccountUseCase {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

class FakeUser extends Fake implements User {}

void main() {
  late ProfileViewModel viewModel;
  late MockDeleteAccountUseCase mockDeleteAccountUseCase;
  late MockAuthRepository mockAuthRepository;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockAuthStateNotifier mockAuthStateNotifier;

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
    children: [
      ChildProfile(
        id: 'child-1',
        firstName: 'Jane',
        lastName: 'Doe',
        birthDate: DateTime(2015, 1, 1),
      ),
    ],
  );

  final testSession = AuthSession(
    user: testUser,
    state: AuthState.authenticated,
  );

  setUpAll(() {
    registerFallbackValue(FakeUser());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockLogoutUseCase = MockLogoutUseCase();
    mockDeleteAccountUseCase = MockDeleteAccountUseCase();
    mockAuthStateNotifier = MockAuthStateNotifier();

    // Default behavior for constructor's loadProfile call
    when(
      () => mockAuthRepository.getUserProfile(),
    ).thenAnswer((_) async => Result.success(testSession));

    when(() => mockAuthStateNotifier.currentUser).thenReturn(testUser);
    when(() => mockAuthStateNotifier.isAuthenticated).thenReturn(true);
    when(() => mockAuthStateNotifier.addListener(any())).thenReturn(null);
    when(() => mockAuthStateNotifier.removeListener(any())).thenReturn(null);

    viewModel = ProfileViewModel(
      authRepository: mockAuthRepository,
      logoutUseCase: mockLogoutUseCase,
      deleteAccountUseCase: mockDeleteAccountUseCase,
      authStateNotifier: mockAuthStateNotifier,
    );
  });

  group('ProfileViewModel', () {
    test('initial state sets loading then success with user data', () async {
      // ViewModel calls loadProfile in constructor
      check(viewModel.isLoading).isFalse();
      check(viewModel.user).isNotNull().equals(testUser);
      check(viewModel.errorMessage).isNull();
    });

    test('loadProfile sets failure state on error', () async {
      // Return null for current user to trigger loadProfile in constructor
      when(() => mockAuthStateNotifier.currentUser).thenReturn(null);

      // Re-initialize to trigger constructor logic
      viewModel = ProfileViewModel(
        authRepository: mockAuthRepository,
        logoutUseCase: mockLogoutUseCase,
        deleteAccountUseCase: mockDeleteAccountUseCase,
        authStateNotifier: mockAuthStateNotifier,
      );

      when(() => mockAuthRepository.getUserProfile()).thenAnswer(
        (_) async => Result.failure(
          const ServerFailure(AppErrorCode.serverError, 'Server error'),
        ),
      );

      await viewModel.loadProfile();

      check(viewModel.isLoading).isFalse();
      check(viewModel.errorMessage).isNotNull().equals('Server error');
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
