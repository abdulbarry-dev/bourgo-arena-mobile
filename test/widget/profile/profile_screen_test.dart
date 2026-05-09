import 'dart:async';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

class MockUpdateUserProfileUseCase extends Mock
    implements UpdateUserProfileUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
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
    isParentAccount: false,
    children: [],
  );

  setUp(() {
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    mockUpdateUserProfileUseCase = MockUpdateUserProfileUseCase();
    mockLogoutUseCase = MockLogoutUseCase();

    locator.registerFactory<GetUserProfileUseCase>(
      () => mockGetUserProfileUseCase,
    );
    locator.registerFactory<UpdateUserProfileUseCase>(
      () => mockUpdateUserProfileUseCase,
    );
    locator.registerFactory<LogoutUseCase>(() => mockLogoutUseCase);
  });

  tearDown(() async {
    await locator.reset();
  });

  testWidgets('ProfileScreen renders user information correctly', (
    tester,
  ) async {
    mockNetworkImagesFor(() async {
      // Arrange
      when(
        () => mockGetUserProfileUseCase(),
      ).thenAnswer((_) async => Success(tUser));

      // Act
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('JOHN DOE'), findsOneWidget);
      expect(find.text('GOLD'), findsOneWidget);
      expect(find.text('100'), findsOneWidget); // Loyalty points
      expect(find.text('10'), findsOneWidget); // Total check-ins
    });
  });

  testWidgets('ProfileScreen shows loading indicator while loading profile', (
    tester,
  ) async {
    mockNetworkImagesFor(() async {
      // Arrange
      final completer = Completer<Result<User, Failure>>();
      when(
        () => mockGetUserProfileUseCase(),
      ).thenAnswer((_) => completer.future);

      // Act
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pump(); // Start building and call initState

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete loading
      completer.complete(Success(tUser));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('JOHN DOE'), findsOneWidget);
    });
  });

  testWidgets('ProfileScreen shows error message on failure', (tester) async {
    mockNetworkImagesFor(() async {
      // Arrange
      when(() => mockGetUserProfileUseCase()).thenAnswer(
        (_) async => const FailureResult(ServerFailure('Failed to load')),
      );

      // Act
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      // Assert
      // Currently, ProfileScreen shows 'Loading error' (fallback) if user is null
      expect(find.text('Loading error'), findsOneWidget);
    });
  });

  testWidgets('Logout button triggers logout flow', (tester) async {
    mockNetworkImagesFor(() async {
      // Set larger surface size for logout button visibility
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      // Arrange
      when(
        () => mockGetUserProfileUseCase(),
      ).thenAnswer((_) async => Success(tUser));
      when(
        () => mockLogoutUseCase(),
      ).thenAnswer((_) async => const Success(null));

      // Act
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const Scaffold(body: Text('Login')),
          ),
        ],
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      final logoutButton = find.text('Log out');
      expect(logoutButton, findsOneWidget);

      await tester.tap(logoutButton);
      await tester.pump();

      // Assert
      verify(() => mockLogoutUseCase()).called(1);
    });
  });
}
