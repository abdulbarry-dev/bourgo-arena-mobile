import 'dart:async';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late MockRegisterUseCase mockRegisterUseCase;

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    registerFallbackValue(const Success<void, Failure>(null));
  });

  Widget createWidgetUnderTest() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              RegisterScreen(registerUseCase: mockRegisterUseCase),
        ),
        GoRoute(
          path: '/verification-method',
          builder: (context, state) =>
              const Scaffold(body: Text('Verification')),
        ),
        GoRoute(
          path: '/family-onboarding',
          builder: (context, state) => const Scaffold(body: Text('Family')),
        ),
      ],
    );

    return MaterialApp.router(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      routerConfig: router,
    );
  }

  Future<void> setupScreenSize(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  group('RegisterScreen -', () {
    testWidgets('renders all fields', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsAtLeastNWidgets(5));
    });

    testWidgets(
      'submit button shows loading and is disabled during async call',
      (tester) async {
        await setupScreenSize(tester);
        final completer = Completer<Result<void, Failure>>();
        when(
          () => mockRegisterUseCase(
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
            email: any(named: 'email'),
            phone: any(named: 'phone'),
            password: any(named: 'password'),
            gender: any(named: 'gender'),
            birthDate: any(named: 'birthDate'),
            isFamilyAccount: any(named: 'isFamilyAccount'),
          ),
        ).thenAnswer((_) => completer.future);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Fill in all fields
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), 'John');
        await tester.enterText(textFields.at(1), 'Doe');
        await tester.enterText(textFields.at(2), 'john@example.com');
        await tester.enterText(textFields.at(3), '123456789');
        // Set birth date via date picker
        await tester.tap(find.byIcon(Symbols.calendar_today));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        // Select gender
        await tester.tap(find.byKey(const Key('gender_dropdown')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Male').last);
        await tester.pumpAndSettle();
        await tester.enterText(textFields.at(5), 'password123');

        final registerButton = find.byType(ElevatedButton);
        await tester.ensureVisible(registerButton);
        await tester.tap(registerButton);

        // Should show loading state
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        final button = tester.widget<ElevatedButton>(registerButton);
        expect(button.onPressed, isNull);

        completer.complete(const Success(null));
        await tester.pumpAndSettle();

        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets('shows SnackBar on failure', (tester) async {
      await setupScreenSize(tester);
      when(
        () => mockRegisterUseCase(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          phone: any(named: 'phone'),
          password: any(named: 'password'),
          gender: any(named: 'gender'),
          birthDate: any(named: 'birthDate'),
          isFamilyAccount: any(named: 'isFamilyAccount'),
        ),
      ).thenAnswer(
        (_) async => FailureResult(AuthFailure('Email already exists')),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      // Fill in all fields
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'John');
      await tester.enterText(textFields.at(1), 'Doe');
      await tester.enterText(textFields.at(2), 'john@example.com');
      await tester.enterText(textFields.at(3), '123456789');
      // Set birth date via date picker
      await tester.tap(find.byIcon(Symbols.calendar_today));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      // Select gender
      await tester.tap(find.byKey(const Key('gender_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Male').last);
      await tester.pumpAndSettle();
      await tester.enterText(textFields.at(5), 'password123');

      final registerButton = find.byType(ElevatedButton);
      await tester.ensureVisible(registerButton);
      await tester.tap(registerButton);

      // Process all microtasks and animations
      await tester.pumpAndSettle();

      verify(
        () => mockRegisterUseCase(
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
          phone: '123456789',
          password: 'password123',
          gender: 'male',
          birthDate: any(named: 'birthDate'),
          isFamilyAccount: false,
        ),
      ).called(1);

      expect(find.text('Email already exists'), findsOneWidget);
    });

    testWidgets('toggles family account', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final toggle = find.byType(Switch);
      await tester.ensureVisible(toggle);
      expect(tester.widget<Switch>(toggle).value, isFalse);

      await tester.tap(toggle);
      await tester.pump();

      expect(tester.widget<Switch>(toggle).value, isTrue);
    });
  });
}
