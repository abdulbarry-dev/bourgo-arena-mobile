import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_time_slots_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/booking/booking_flow_screen.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/activity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockGetActivitiesUseCase extends Mock implements GetActivitiesUseCase {}

class MockGetTimeSlotsUseCase extends Mock implements GetTimeSlotsUseCase {}

void main() {
  late MockGetActivitiesUseCase mockGetActivitiesUseCase;
  late MockGetTimeSlotsUseCase mockGetTimeSlotsUseCase;

  final tActivities = [
    const Activity(
      id: '1',
      title: 'Soccer',
      category: 'Outdoor',
      basePrice: 50.0,
      currency: 'EUR',
      imageUrl: 'https://example.com/image1.png',
      description: 'Soccer desc',
      icon: 'sports_soccer',
      features: ['Pitch'],
    ),
    const Activity(
      id: '2',
      title: 'Tennis',
      category: 'Outdoor',
      basePrice: 30.0,
      currency: 'EUR',
      imageUrl: 'https://example.com/image2.png',
      description: 'Tennis desc',
      icon: 'sports_tennis',
      features: ['Court'],
    ),
  ];

  final tTimeSlots = [
    const TimeSlot(time: '18:00', available: true),
    const TimeSlot(time: '19:00', available: true),
  ];

  setUp(() {
    mockGetActivitiesUseCase = MockGetActivitiesUseCase();
    mockGetTimeSlotsUseCase = MockGetTimeSlotsUseCase();

    locator.registerFactory<GetActivitiesUseCase>(
      () => mockGetActivitiesUseCase,
    );
    locator.registerFactory<GetTimeSlotsUseCase>(() => mockGetTimeSlotsUseCase);

    when(
      () => mockGetActivitiesUseCase(),
    ).thenAnswer((_) async => Result.success(tActivities));
    when(
      () => mockGetTimeSlotsUseCase(any()),
    ).thenAnswer((_) async => Result.success(tTimeSlots));
  });

  tearDown(() async {
    await locator.reset();
  });

  Widget createWidgetUnderTest({Activity? initialActivity}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BookingFlowScreen(initialActivity: initialActivity),
    );
  }

  testWidgets('renders Step 1 (Select Sport) by default', (tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(createWidgetUnderTest());
      // We don't check for CircularProgressIndicator here because it might
      // be gone by the time we can check it due to immediate mock response.
      await tester.pumpAndSettle();

      expect(find.text('SOCCER'), findsOneWidget);
      expect(find.text('TENNIS'), findsOneWidget);
      expect(find.byType(ActivityCard), findsNWidgets(2));
    });
  });

  testWidgets('renders Step 2 (Select Time) if initialActivity is provided', (
    tester,
  ) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        createWidgetUnderTest(initialActivity: tActivities.first),
      );
      await tester.pumpAndSettle();

      expect(find.text('18:00'), findsOneWidget);
      expect(find.text('19:00'), findsOneWidget);
    });
  });

  testWidgets('selecting an activity moves to Step 2', (tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('SOCCER'));
      await tester.pumpAndSettle();

      expect(find.text('18:00'), findsOneWidget);
    });
  });

  testWidgets('back button moves to previous step', (tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Move to step 2
      await tester.tap(find.text('SOCCER'));
      await tester.pumpAndSettle();
      expect(find.text('18:00'), findsOneWidget);

      // Tap back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('SOCCER'), findsOneWidget);
      expect(find.text('TENNIS'), findsOneWidget);
    });
  });

  testWidgets('selecting a slot enables confirmation button', (tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        createWidgetUnderTest(initialActivity: tActivities.first),
      );
      await tester.pumpAndSettle();

      final confirmButtonFinder = find.byType(ElevatedButton);

      // Initially disabled (no slot selected)
      var confirmButton = tester.widget<ElevatedButton>(confirmButtonFinder);
      expect(confirmButton.onPressed, isNull);

      // Select a slot
      await tester.tap(find.text('18:00'));
      await tester.pump();

      // Now enabled
      confirmButton = tester.widget<ElevatedButton>(confirmButtonFinder);
      expect(confirmButton.onPressed, isNotNull);
    });
  });
}
