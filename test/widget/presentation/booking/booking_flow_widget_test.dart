import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/booking/booking_flow_screen.dart';
import 'package:bourgo_arena_mobile/presentation/booking/viewmodels/booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingViewModel extends Mock implements BookingViewModel {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockBookingViewModel mockViewModel;
  late MockGoRouter mockGoRouter;
  late VoidCallback? listener;

  const testActivity = Activity(
    id: 'test-1',
    title: 'Test Sport',
    name: 'Test Sport',
    category: 'Outdoor',
    basePrice: 25.0,
    currency: '€',
    imageUrl: 'https://example.com/test.png',
    images: ['https://example.com/test.png'],
    icon: 'sports_soccer',
    description: 'Test Description',
    features: ['Feature 1'],
  );

  const testSlot = TimeSlot(time: '10:00', available: true);

  setUpAll(() {
    HttpOverrides.global = _FakeHttpOverrides();
    registerFallbackValue(const Locale('en'));
    registerFallbackValue(testActivity);
    registerFallbackValue(testSlot);
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockViewModel = MockBookingViewModel();
    mockGoRouter = MockGoRouter();
    listener = null;

    // Default mock behaviors
    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.isFamilyAccount).thenReturn(false);
    when(() => mockViewModel.errorMessage).thenReturn(null);
    when(() => mockViewModel.activities).thenReturn([testActivity]);
    when(() => mockViewModel.availableSlots).thenReturn([testSlot]);
    when(() => mockViewModel.currentStep).thenReturn(0);
    when(() => mockViewModel.selectedActivity).thenReturn(null);
    when(() => mockViewModel.selectedDate).thenReturn(DateTime(2024, 1, 1));
    when(() => mockViewModel.selectedSlot).thenReturn(null);
    when(() => mockViewModel.priceToPay).thenReturn(0);
    when(() => mockViewModel.isPricingLoading).thenReturn(false);
    when(() => mockViewModel.projectedPoints).thenReturn(0);
    when(
      () => mockViewModel.paymentMethod,
    ).thenReturn(AppConstants.paymentMethodCardId);

    when(() => mockViewModel.addListener(any())).thenAnswer((invocation) {
      listener = invocation.positionalArguments[0] as VoidCallback;
    });
    when(() => mockViewModel.removeListener(any())).thenReturn(null);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: BourgoTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('fr')],
      home: InheritedGoRouter(
        goRouter: mockGoRouter,
        child: BookingFlowScreen(viewModel: mockViewModel),
      ),
    );
  }

  group('BookingFlowScreen Widget Tests', () {
    testWidgets('Step 1: shows activity list and handles selection', (
      tester,
    ) async {
      when(() => mockViewModel.currentStep).thenReturn(0);
      when(() => mockViewModel.activities).thenReturn([testActivity]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // ActivityCard uses toUpperCase()
      expect(find.text('TEST SPORT'), findsOneWidget);

      await tester.tap(find.text('TEST SPORT'));
      verify(() => mockViewModel.selectActivity(testActivity)).called(1);
    });

    testWidgets('Step 2: shows time slots and handles navigation', (
      tester,
    ) async {
      when(() => mockViewModel.currentStep).thenReturn(2);
      when(() => mockViewModel.selectedActivity).thenReturn(testActivity);
      when(() => mockViewModel.selectedDate).thenReturn(DateTime(2024, 1, 1));
      when(() => mockViewModel.availableSlots).thenReturn([
        const TimeSlot(
          time: '10:00',
          available: true,
          startTime: '10:00:00',
          endTime: '11:00:00',
          durationMinutes: 60,
          dayOfWeek: 1,
        ),
      ]);
      when(() => mockViewModel.selectedSlot).thenReturn(null);
      when(() => mockViewModel.priceToPay).thenReturn(25.0);
      when(() => mockViewModel.isPricingLoading).thenReturn(false);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Check if time slot is visible (formatted as "10:00 - 11:00")
      expect(find.text('10:00 - 11:00'), findsOneWidget);

      // Select a slot
      await tester.tap(find.text('10:00 - 11:00'));
      verify(() => mockViewModel.selectSlot(any())).called(1);

      // Confirm button should be disabled if no slot selected
      final confirmBtnFinder = find.byType(ElevatedButton);
      expect(tester.widget<ElevatedButton>(confirmBtnFinder).enabled, isFalse);

      // Mock slot selected and notify listener
      when(() => mockViewModel.selectedSlot).thenReturn(
        const TimeSlot(
          time: '10:00',
          available: true,
          startTime: '10:00:00',
          endTime: '11:00:00',
          durationMinutes: 60,
        ),
      );
      listener?.call();
      await tester.pump();

      expect(tester.widget<ElevatedButton>(confirmBtnFinder).enabled, isTrue);
      await tester.tap(confirmBtnFinder);
      verify(() => mockViewModel.nextStep()).called(1);
    });

    testWidgets('Step 3: shows confirmation summary and handles payment', (
      tester,
    ) async {
      when(() => mockViewModel.currentStep).thenReturn(3);
      when(() => mockViewModel.selectedActivity).thenReturn(testActivity);
      when(() => mockViewModel.selectedSlot).thenReturn(
        const TimeSlot(
          time: '10:00',
          available: true,
          startTime: '10:00:00',
          endTime: '11:00:00',
          durationMinutes: 60,
        ),
      );
      when(() => mockViewModel.selectedDate).thenReturn(DateTime(2024, 1, 1));
      when(() => mockViewModel.priceToPay).thenReturn(25.0);
      when(() => mockViewModel.isPricingLoading).thenReturn(false);
      when(() => mockViewModel.requiresDeposit).thenReturn(false);
      when(
        () => mockViewModel.paymentMethod,
      ).thenReturn(AppConstants.paymentMethodCardId);
      when(() => mockViewModel.makeReservation()).thenAnswer((_) async => true);
      when(
        () => mockGoRouter.push(any<String>(), extra: any(named: 'extra')),
      ).thenAnswer((_) async => null);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Verify summary information — price uses currency from activity ('€')
      expect(find.text('25.00 €'), findsOneWidget);
      expect(find.text('10:00'), findsAtLeastNWidgets(1));

      // Pay button
      final payBtnFinder = find.byType(ElevatedButton);
      await tester.tap(payBtnFinder);
      verify(() => mockViewModel.makeReservation()).called(1);

      // Wait for navigation
      await tester.pumpAndSettle();
      verify(
        () => mockGoRouter.push('/booking-success', extra: testActivity),
      ).called(1);
    });

    testWidgets('shows loading spinner when isLoading is true', (tester) async {
      when(() => mockViewModel.isLoading).thenReturn(true);
      when(() => mockViewModel.currentStep).thenReturn(0);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

class _FakeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeHttpClient();
}

class _FakeHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpRequest();

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      _FakeHttpRequest();
}

class _FakeHttpRequest extends Fake implements HttpClientRequest {
  @override
  Encoding get encoding => utf8;

  @override
  set encoding(Encoding value) {}

  @override
  Future<HttpClientResponse> close() async {
    return _FakeHttpResponse.fromBytes(_transparentPngBytes);
  }
}

class _FakeHttpHeaders extends Fake implements HttpHeaders {}

class _FakeHttpResponse extends Fake implements HttpClientResponse {
  _FakeHttpResponse.fromBytes(this._bytes);

  final List<int> _bytes;

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _bytes.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  HttpHeaders get headers => _FakeHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_bytes]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError ?? false,
    );
  }
}

final List<int> _transparentPngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);
