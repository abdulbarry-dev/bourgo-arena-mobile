import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_time_slots_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/booking/viewmodels/booking_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetActivitiesUseCase extends Mock implements GetActivitiesUseCase {}

class MockGetTimeSlotsUseCase extends Mock implements GetTimeSlotsUseCase {}

void main() {
  late BookingViewModel viewModel;
  late MockGetActivitiesUseCase mockGetActivitiesUseCase;
  late MockGetTimeSlotsUseCase mockGetTimeSlotsUseCase;

  final tActivities = [
    const Activity(
      id: '1',
      title: 'Soccer',
      category: 'Outdoor',
      basePrice: 50.0,
      currency: 'EUR',
      imageUrl: 'image1',
      description: 'Soccer desc',
      icon: 'sports_soccer',
      features: ['Pitch', 'Lighting'],
    ),
    const Activity(
      id: '2',
      title: 'Tennis',
      category: 'Outdoor',
      basePrice: 30.0,
      currency: 'EUR',
      imageUrl: 'image2',
      description: 'Tennis desc',
      icon: 'sports_tennis',
      features: ['Court', 'Rackets'],
    ),
  ];

  final tTimeSlots = [
    const TimeSlot(time: '18:00', available: true),
    const TimeSlot(time: '19:00', available: true),
  ];

  setUp(() {
    mockGetActivitiesUseCase = MockGetActivitiesUseCase();
    mockGetTimeSlotsUseCase = MockGetTimeSlotsUseCase();

    // Default mocks
    when(
      () => mockGetActivitiesUseCase(),
    ).thenAnswer((_) async => Result.success(tActivities));
    when(
      () => mockGetTimeSlotsUseCase(any()),
    ).thenAnswer((_) async => Result.success(tTimeSlots));
  });

  group('BookingViewModel', () {
    test('initial state when no activity is provided', () async {
      viewModel = BookingViewModel(
        getActivitiesUseCase: mockGetActivitiesUseCase,
        getTimeSlotsUseCase: mockGetTimeSlotsUseCase,
      );

      expect(viewModel.currentStep, 0);
      expect(viewModel.selectedActivity, isNull);
      expect(viewModel.isLoading, isTrue);

      // Wait for activities to load
      await Future.delayed(Duration.zero);

      expect(viewModel.activities, tActivities);
      expect(viewModel.isLoading, isFalse);
    });

    test('initial state when initial activity is provided', () async {
      viewModel = BookingViewModel(
        getActivitiesUseCase: mockGetActivitiesUseCase,
        getTimeSlotsUseCase: mockGetTimeSlotsUseCase,
        initialActivity: tActivities.first,
      );

      expect(viewModel.currentStep, 1);
      expect(viewModel.selectedActivity, tActivities.first);
      expect(viewModel.isLoading, isTrue);

      // Wait for slots to load
      await Future.delayed(Duration.zero);

      expect(viewModel.availableSlots, tTimeSlots);
      expect(viewModel.isLoading, isFalse);
    });

    test(
      'selectActivity should update selected activity and move to step 1',
      () async {
        viewModel = BookingViewModel(
          getActivitiesUseCase: mockGetActivitiesUseCase,
          getTimeSlotsUseCase: mockGetTimeSlotsUseCase,
        );

        await Future.delayed(Duration.zero);

        viewModel.selectActivity(tActivities.last);

        expect(viewModel.selectedActivity, tActivities.last);
        expect(viewModel.currentStep, 1);
        expect(viewModel.isLoading, isTrue);

        await Future.delayed(Duration.zero);
        expect(viewModel.availableSlots, tTimeSlots);
      },
    );

    test('nextStep and previousStep should navigate correctly', () {
      viewModel = BookingViewModel(
        getActivitiesUseCase: mockGetActivitiesUseCase,
        getTimeSlotsUseCase: mockGetTimeSlotsUseCase,
      );

      expect(viewModel.currentStep, 0);
      viewModel.nextStep();
      expect(viewModel.currentStep, 1);
      viewModel.nextStep();
      expect(viewModel.currentStep, 2);
      viewModel.nextStep(); // Should stay at 2
      expect(viewModel.currentStep, 2);

      viewModel.previousStep();
      expect(viewModel.currentStep, 1);
      viewModel.previousStep();
      expect(viewModel.currentStep, 0);
      viewModel.previousStep(); // Should stay at 0
      expect(viewModel.currentStep, 0);
    });

    test('selectDate should refresh slots', () async {
      viewModel = BookingViewModel(
        getActivitiesUseCase: mockGetActivitiesUseCase,
        getTimeSlotsUseCase: mockGetTimeSlotsUseCase,
        initialActivity: tActivities.first,
      );

      await Future.delayed(Duration.zero);

      final newDate = DateTime.now().add(const Duration(days: 1));
      viewModel.selectDate(newDate);

      expect(viewModel.selectedDate, newDate);
      expect(viewModel.selectedSlot, isNull);
      expect(viewModel.isLoading, isTrue);

      await Future.delayed(Duration.zero);
      verify(() => mockGetTimeSlotsUseCase(tActivities.first.id)).called(2);
    });

    test('selectSlot should update selected slot', () {
      viewModel = BookingViewModel(
        getActivitiesUseCase: mockGetActivitiesUseCase,
        getTimeSlotsUseCase: mockGetTimeSlotsUseCase,
      );

      viewModel.selectSlot(tTimeSlots.first);
      expect(viewModel.selectedSlot, tTimeSlots.first);
    });

    test('setPaymentMethod should update payment method', () {
      viewModel = BookingViewModel(
        getActivitiesUseCase: mockGetActivitiesUseCase,
        getTimeSlotsUseCase: mockGetTimeSlotsUseCase,
      );

      viewModel.setPaymentMethod('cash');
      expect(viewModel.paymentMethod, 'cash');
    });

    test('loading activities failure sets error message', () async {
      when(
        () => mockGetActivitiesUseCase(),
      ).thenAnswer((_) async => Result.failure(const ServerFailure('Failed')));

      viewModel = BookingViewModel(
        getActivitiesUseCase: mockGetActivitiesUseCase,
        getTimeSlotsUseCase: mockGetTimeSlotsUseCase,
      );

      await Future.delayed(Duration.zero);

      expect(viewModel.error, 'activities_loading_failed');
      expect(viewModel.isLoading, isFalse);
    });

    test('loading slots failure sets error message', () async {
      when(
        () => mockGetTimeSlotsUseCase(any()),
      ).thenAnswer((_) async => Result.failure(const ServerFailure('Failed')));

      viewModel = BookingViewModel(
        getActivitiesUseCase: mockGetActivitiesUseCase,
        getTimeSlotsUseCase: mockGetTimeSlotsUseCase,
        initialActivity: tActivities.first,
      );

      await Future.delayed(Duration.zero);

      expect(viewModel.error, 'slots_loading_failed');
      expect(viewModel.availableSlots, isEmpty);
      expect(viewModel.isLoading, isFalse);
    });
  });
}
