import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import '../../data/repositories/repository_test_fixtures.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/activities/viewmodels/activities_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checks/checks.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';

class FakeGetActivitiesUseCase implements GetActivitiesUseCase {
  Result<List<Activity>, Failure> stubbedResult = const Success([]);
  Object? exceptionToThrow;

  @override
  Future<Result<List<Activity>, Failure>> call() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return stubbedResult;
  }
}

class FakeGetUserBookingsUseCase implements GetUserBookingsUseCase {
  Result<List<Reservation>, Failure> stubbedResult = const Success([]);

  @override
  Future<Result<List<Reservation>, Failure>> call() async => stubbedResult;
}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

void main() {
  late ActivitiesViewModel viewModel;
  late FakeGetActivitiesUseCase fakeGetActivitiesUseCase;
  late FakeGetUserBookingsUseCase fakeGetUserBookingsUseCase;
  late MockAuthStateNotifier mockAuthStateNotifier;

  setUp(() {
    fakeGetActivitiesUseCase = FakeGetActivitiesUseCase();
    fakeGetUserBookingsUseCase = FakeGetUserBookingsUseCase();
    mockAuthStateNotifier = MockAuthStateNotifier();

    when(() => mockAuthStateNotifier.isAuthenticated).thenReturn(true);

    viewModel = ActivitiesViewModel(
      getActivitiesUseCase: fakeGetActivitiesUseCase,
      getUserBookingsUseCase: fakeGetUserBookingsUseCase,
      authStateNotifier: mockAuthStateNotifier,
    );
  });

  group('ActivitiesViewModel', () {
    test('initial state', () {
      check(viewModel.activities).isEmpty();
      check(viewModel.reservations).isEmpty();
      check(viewModel.isLoading).isFalse();
      check(viewModel.errorMessage).isNull();
    });

    test('loadData handles success path', () async {
      final activities = [testActivityEntity(id: '1')];
      final reservations = [testReservationEntity(id: 'r1', activityId: '1')];

      fakeGetActivitiesUseCase.stubbedResult = Success(activities);
      fakeGetUserBookingsUseCase.stubbedResult = Success(reservations);

      await viewModel.loadData();

      check(viewModel.isLoading).isFalse();
      check(viewModel.activities).equals(activities);
      check(viewModel.reservations).equals(reservations);
      check(viewModel.errorMessage).isNull();
    });

    test('loadData handles partial failure (activities)', () async {
      fakeGetActivitiesUseCase.stubbedResult = FailureResult(
        Failure.server(AppErrorCode.serverError, 'fail'),
      );
      fakeGetUserBookingsUseCase.stubbedResult = const Success([]);

      await viewModel.loadData();

      check(viewModel.errorMessage).equals('activities_loading_failed');
    });

    test('loadData handles partial failure (bookings)', () async {
      fakeGetActivitiesUseCase.stubbedResult = const Success([]);
      fakeGetUserBookingsUseCase.stubbedResult = FailureResult(
        Failure.server(AppErrorCode.serverError, 'fail'),
      );

      await viewModel.loadData();

      check(viewModel.errorMessage).isNull();
    });

    test('loadData handles exception', () async {
      fakeGetActivitiesUseCase.exceptionToThrow = Exception('crash');

      await viewModel.loadData();

      check(viewModel.errorMessage).equals('loading_failed');
      check(viewModel.isLoading).isFalse();
    });
  });
}
