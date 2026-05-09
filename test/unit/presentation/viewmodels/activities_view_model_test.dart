import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/activities/viewmodels/activities_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGetActivities extends Mock implements GetActivitiesUseCase {}

class MockGetUserBookings extends Mock implements GetUserBookingsUseCase {}

void main() {
  late MockGetActivities mockActivities;
  late MockGetUserBookings mockBookings;

  final tActivities = [
    const Activity(
      id: 'a1',
      title: 'S',
      category: 'C',
      basePrice: 0,
      currency: 'EUR',
      imageUrl: '',
      description: '',
      icon: '',
      features: [],
    ),
  ];
  final tReservations = [
    const Reservation(
      id: 'r1',
      activityId: 'a1',
      activityTitle: 'S',
      date: '2026-01-01',
      time: '10:00',
      duration: '60',
      price: 0,
      status: 'confirmed',
      paymentStatus: 'paid',
      qrCode: 'q',
    ),
  ];

  setUp(() {
    mockActivities = MockGetActivities();
    mockBookings = MockGetUserBookings();
    when(
      () => mockActivities(),
    ).thenAnswer((_) async => Result.success(tActivities));
    when(
      () => mockBookings(),
    ).thenAnswer((_) async => Result.success(tReservations));
  });

  test('loadData populates activities and reservations', () async {
    final vm = ActivitiesViewModel(
      getActivitiesUseCase: mockActivities,
      getUserBookingsUseCase: mockBookings,
    );
    await vm.loadData();
    expect(vm.activities, tActivities);
    expect(vm.reservations, tReservations);
    expect(vm.error, isNull);
  });

  test('loadData failure sets error', () async {
    when(
      () => mockActivities(),
    ).thenAnswer((_) async => FailureResult(const ServerFailure('err')));
    final vm = ActivitiesViewModel(
      getActivitiesUseCase: mockActivities,
      getUserBookingsUseCase: mockBookings,
    );
    await vm.loadData();
    expect(vm.error, isNotNull);
  });

  test('loadData bookings failure sets bookings error', () async {
    when(
      () => mockBookings(),
    ).thenAnswer((_) async => FailureResult(const ServerFailure('err')));
    final vm = ActivitiesViewModel(
      getActivitiesUseCase: mockActivities,
      getUserBookingsUseCase: mockBookings,
    );
    await vm.loadData();
    expect(vm.error, isNotNull);
  });
}
