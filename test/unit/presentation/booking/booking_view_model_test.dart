import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation_with_payment.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_time_slots_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/cancel_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/make_reservation_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/project_points_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/pricing/get_contextual_price_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/booking/viewmodels/booking_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockGetActivitiesUseCase extends Mock implements GetActivitiesUseCase {}

class MockGetTimeSlotsUseCase extends Mock implements GetTimeSlotsUseCase {}

class MockGetUserBookingsUseCase extends Mock
    implements GetUserBookingsUseCase {}

class MockMakeReservationUseCase extends Mock
    implements MakeReservationUseCase {}

class MockCancelBookingUseCase extends Mock implements CancelBookingUseCase {}

class MockGetFamilyMembersUseCase extends Mock
    implements GetFamilyMembersUseCase {}

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

class MockGetContextualPriceUseCase extends Mock
    implements GetContextualPriceUseCase {}

class MockGetMemberTierUseCase extends Mock implements GetMemberTierUseCase {}

class MockProjectPointsUseCase extends Mock implements ProjectPointsUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const Reservation(
        id: 'fake',
        activityId: 'fake',
        activityTitle: 'fake',
        date: 'fake',
        time: 'fake',
        duration: 'fake',
        price: 0,
        status: 'fake',
        paymentStatus: 'fake',
        qrCode: 'fake',
      ),
    );
  });

  late BookingViewModel viewModel;
  late MockGetActivitiesUseCase mockGetActivitiesUseCase;
  late MockGetTimeSlotsUseCase mockGetTimeSlotsUseCase;
  late MockGetUserBookingsUseCase mockGetUserBookingsUseCase;
  late MockMakeReservationUseCase mockMakeReservationUseCase;
  late MockCancelBookingUseCase mockCancelBookingUseCase;
  late MockGetFamilyMembersUseCase mockGetFamilyMembersUseCase;
  late MockGetUserProfileUseCase mockGetUserProfileUseCase;
  late MockGetContextualPriceUseCase mockGetContextualPriceUseCase;
  late MockGetMemberTierUseCase mockGetMemberTierUseCase;
  late MockProjectPointsUseCase mockProjectPointsUseCase;

  final tActivities = [
    const Activity(
      id: '1',
      title: 'Soccer',
      name: 'Soccer',
      category: 'Outdoor',
      basePrice: 50.0,
      currency: 'EUR',
      imageUrl: 'image1',
      images: ['image1'],
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

  setUp(() {
    mockGetActivitiesUseCase = MockGetActivitiesUseCase();
    mockGetTimeSlotsUseCase = MockGetTimeSlotsUseCase();
    mockGetUserBookingsUseCase = MockGetUserBookingsUseCase();
    mockMakeReservationUseCase = MockMakeReservationUseCase();
    mockCancelBookingUseCase = MockCancelBookingUseCase();
    mockGetFamilyMembersUseCase = MockGetFamilyMembersUseCase();
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    mockGetContextualPriceUseCase = MockGetContextualPriceUseCase();
    mockGetMemberTierUseCase = MockGetMemberTierUseCase();
    mockProjectPointsUseCase = MockProjectPointsUseCase();

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
    ).thenAnswer((_) async => Result.success(
      ReservationWithPayment(reservation: tReservations.first),
    ));
    when(
      () => mockCancelBookingUseCase(any()),
    ).thenAnswer((_) async => Result.success(null));
    when(
      () => mockGetFamilyMembersUseCase(),
    ).thenAnswer((_) async => Result.success([]));
    when(() => mockGetUserProfileUseCase()).thenAnswer(
      (_) async => Result.failure(
        const ServerFailure(AppErrorCode.serverError, 'error'),
      ),
    );
  });

  BookingViewModel createViewModel({Activity? initialActivity}) {
    return BookingViewModel(
      getActivitiesUseCase: mockGetActivitiesUseCase,
      getTimeSlotsUseCase: mockGetTimeSlotsUseCase,
      getUserBookingsUseCase: mockGetUserBookingsUseCase,
      makeReservationUseCase: mockMakeReservationUseCase,
      cancelBookingUseCase: mockCancelBookingUseCase,
      getFamilyMembersUseCase: mockGetFamilyMembersUseCase,
      getUserProfileUseCase: mockGetUserProfileUseCase,
      getContextualPriceUseCase: mockGetContextualPriceUseCase,
      getMemberTierUseCase: mockGetMemberTierUseCase,
      projectPointsUseCase: mockProjectPointsUseCase,
      initialActivity: initialActivity,
    );
  }

  group('BookingViewModel', () {
    test('initialization calls getUserBookings and loads state', () async {
      viewModel = createViewModel();
      expect(viewModel.isLoading, isTrue);
      await Future.delayed(Duration.zero);
      expect(viewModel.userBookings, tReservations);
      expect(viewModel.isLoading, isFalse);
    });
  });
}
