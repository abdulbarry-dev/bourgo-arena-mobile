import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import '../../data/repositories/repository_test_fixtures.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/activities/viewmodels/activities_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checks/checks.dart';

class MockGetActivitiesUseCase extends Mock implements GetActivitiesUseCase {}

class MockGetUserBookingsUseCase extends Mock
    implements GetUserBookingsUseCase {}

void main() {
  late ActivitiesViewModel viewModel;
  late MockGetActivitiesUseCase mockGetActivitiesUseCase;
  late MockGetUserBookingsUseCase mockGetUserBookingsUseCase;

  setUp(() {
    mockGetActivitiesUseCase = MockGetActivitiesUseCase();
    mockGetUserBookingsUseCase = MockGetUserBookingsUseCase();
    viewModel = ActivitiesViewModel(
      getActivitiesUseCase: mockGetActivitiesUseCase,
      getUserBookingsUseCase: mockGetUserBookingsUseCase,
    );
  });

  group('ActivitiesViewModel', () {
    test('initial state', () {
      check(viewModel.activities).isEmpty();
      check(viewModel.reservations).isEmpty();
      check(viewModel.isLoading).isFalse();
      check(viewModel.error).isNull();
    });

    test('loadData handles success path', () async {
      final activities = [testActivityEntity(id: '1')];
      final reservations = [testReservationEntity(id: 'r1', activityId: '1')];

      when(
        () => mockGetActivitiesUseCase(),
      ).thenAnswer((_) async => Success(activities));
      when(
        () => mockGetUserBookingsUseCase(),
      ).thenAnswer((_) async => Success(reservations));

      await viewModel.loadData();

      check(viewModel.isLoading).isFalse();
      check(viewModel.activities).equals(activities);
      check(viewModel.reservations).equals(reservations);
      check(viewModel.error).isNull();
    });

    test('loadData handles partial failure (activities)', () async {
      when(
        () => mockGetActivitiesUseCase(),
      ).thenAnswer((_) async => FailureResult(Failure.server('fail')));
      when(
        () => mockGetUserBookingsUseCase(),
      ).thenAnswer((_) async => Success([]));

      await viewModel.loadData();

      check(viewModel.error).equals('activities_loading_failed');
    });

    test('loadData handles partial failure (bookings)', () async {
      when(
        () => mockGetActivitiesUseCase(),
      ).thenAnswer((_) async => Success([]));
      when(
        () => mockGetUserBookingsUseCase(),
      ).thenAnswer((_) async => FailureResult(Failure.server('fail')));

      await viewModel.loadData();

      check(viewModel.error).equals('bookings_loading_failed');
    });

    test('loadData handles exception', () async {
      when(() => mockGetActivitiesUseCase()).thenThrow(Exception('crash'));

      await viewModel.loadData();

      check(viewModel.error).equals('loading_failed');
      check(viewModel.isLoading).isFalse();
    });
  });
}
