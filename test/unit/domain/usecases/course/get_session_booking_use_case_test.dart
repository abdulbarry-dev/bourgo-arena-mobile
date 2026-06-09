import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/session_booking.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_session_booking_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCourseRepository extends Mock implements CourseRepository {}

void main() {
  late MockCourseRepository repository;
  late GetSessionBookingUseCase useCase;

  setUp(() {
    repository = MockCourseRepository();
    useCase = GetSessionBookingUseCase(repository);
  });

  test('returns session booking on success', () async {
    final tBooking = SessionBooking(
      id: '300',
      sessionId: '101',
      status: 'booked',
      bookedAt: DateTime(2026, 6, 10, 8, 0),
    );
    when(
      () => repository.getSessionBooking(any(), any()),
    ).thenAnswer((_) async => Success(tBooking));

    final result = await useCase('c1', 's1');

    expect(result, isA<Success<SessionBooking, Failure>>());
    expect((result as Success).data.status, 'booked');
    verify(() => repository.getSessionBooking('c1', 's1')).called(1);
  });

  test('propagates repository failures', () async {
    when(() => repository.getSessionBooking(any(), any())).thenAnswer(
      (_) async => FailureResult(
        const ServerFailure(AppErrorCode.serverError, 'Server error'),
      ),
    );

    final result = await useCase('c1', 's1');

    expect(result, isA<FailureResult<SessionBooking, Failure>>());
  });
}
