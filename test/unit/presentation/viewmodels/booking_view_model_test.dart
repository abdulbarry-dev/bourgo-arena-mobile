import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_time_slots_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/cancel_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/make_reservation_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/booking/viewmodels/booking_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetActivitiesUseCase extends Mock implements GetActivitiesUseCase {}

class MockGetTimeSlotsUseCase extends Mock implements GetTimeSlotsUseCase {}

class MockGetUserBookingsUseCase extends Mock
    implements GetUserBookingsUseCase {}

class MockMakeReservationUseCase extends Mock
    implements MakeReservationUseCase {}

class MockCancelBookingUseCase extends Mock implements CancelBookingUseCase {}

void main() {
  late BookingViewModel viewModel;
  late MockGetActivitiesUseCase mockGetActivitiesUseCase;
  late MockGetTimeSlotsUseCase mockGetTimeSlotsUseCase;
  late MockGetUserBookingsUseCase mockGetUserBookingsUseCase;
  late MockMakeReservationUseCase mockMakeReservationUseCase;
  late MockCancelBookingUseCase mockCancelBookingUseCase;

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
  ];

  final tTimeSlots = [const TimeSlot(time: '18:00', available: true)];

  final tReservations = [
    const Reservation(
      id: 'res-1',
      activityId: '1',
      activityTitle: 'Outdoor',
      date: '2026-05-10',
      time: '18:00',
      duration: '60 min',
      price: 50.0,
      status: 'confirmed',
      paymentStatus: 'paid',
      qrCode: 'qr-1',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(
      const Reservation(
        id: '',
        activityId: '',
        activityTitle: '',
        date: '',
        time: '',
        duration: '',
        price: 0,
        status: '',
        paymentStatus: '',
        qrCode: '',
      ),
    );
  });

  setUp(() {
    mockGetActivitiesUseCase = MockGetActivitiesUseCase();
    mockGetTimeSlotsUseCase = MockGetTimeSlotsUseCase();
    mockGetUserBookingsUseCase = MockGetUserBookingsUseCase();
    mockMakeReservationUseCase = MockMakeReservationUseCase();
    mockCancelBookingUseCase = MockCancelBookingUseCase();

    // Default mocks
    when(
      () => mockGetActivitiesUseCase(),
    ).thenAnswer((_) async => Result.success(tActivities));
    when(
      () => mockGetTimeSlotsUseCase(any()),
    ).thenAnswer((_) async => Result.success(tTimeSlots));
    when(
      () => mockGetUserBookingsUseCase(),
    ).thenAnswer((_) async => Result.success(tReservations));
    when(
      () => mockMakeReservationUseCase(any()),
    ).thenAnswer((_) async => Result.success(tReservations.first));
    when(
      () => mockCancelBookingUseCase(any()),
    ).thenAnswer((_) async => Result.success(null));
  });

  BookingViewModel createViewModel({Activity? initialActivity}) {
    return BookingViewModel(
      getActivitiesUseCase: mockGetActivitiesUseCase,
      getTimeSlotsUseCase: mockGetTimeSlotsUseCase,
      getUserBookingsUseCase: mockGetUserBookingsUseCase,
      makeReservationUseCase: mockMakeReservationUseCase,
      cancelBookingUseCase: mockCancelBookingUseCase,
      initialActivity: initialActivity,
    );
  }

  group('BookingViewModel', () {
    test('initialization calls getUserBookings and loads state', () async {
      viewModel = createViewModel();

      expect(viewModel.isLoading, isTrue);
      await Future.delayed(Duration.zero);

      verify(() => mockGetUserBookingsUseCase()).called(1);
      expect(viewModel.userBookings, tReservations);
      expect(viewModel.activities, tActivities);
      expect(viewModel.isLoading, isFalse);
    });

    test('makeReservation success clears form and returns true', () async {
      viewModel = createViewModel();
      await Future.delayed(Duration.zero);

      viewModel.selectActivity(tActivities.first);
      await Future.delayed(Duration.zero);
      viewModel.selectSlot(tTimeSlots.first);

      final success = await viewModel.makeReservation();

      expect(success, isTrue);
      verify(() => mockMakeReservationUseCase(any())).called(1);
      expect(viewModel.selectedActivity, isNull);
      expect(viewModel.selectedSlot, isNull);
      expect(viewModel.currentStep, 0);
    });

    test('makeReservation failure exposes error', () async {
      when(
        () => mockMakeReservationUseCase(any()),
      ).thenAnswer((_) async => Result.failure(const ServerFailure('Failed')));

      viewModel = createViewModel();
      await Future.delayed(Duration.zero);

      viewModel.selectActivity(tActivities.first);
      await Future.delayed(Duration.zero);
      viewModel.selectSlot(tTimeSlots.first);

      final success = await viewModel.makeReservation();

      expect(success, isFalse);
      expect(viewModel.error, 'reservation_failed');
    });

    test('cancelBooking calls use case and reloads bookings', () async {
      viewModel = createViewModel();
      await Future.delayed(Duration.zero);

      await viewModel.cancelBooking('res-1');

      verify(() => mockCancelBookingUseCase('res-1')).called(1);
      verify(
        () => mockGetUserBookingsUseCase(),
      ).called(2); // init + after cancel
    });

    test('loadUserBookings failure sets error', () async {
      when(
        () => mockGetUserBookingsUseCase(),
      ).thenAnswer((_) async => Result.failure(const ServerFailure('Error')));

      viewModel = createViewModel();
      await Future.delayed(Duration.zero);

      expect(viewModel.error, 'bookings_loading_failed');
    });
  });
}
