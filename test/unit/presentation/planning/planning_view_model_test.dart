import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockGetCoursesUseCase extends Mock implements GetCoursesUseCase {}

class MockGetUserBookingsUseCase extends Mock
    implements GetUserBookingsUseCase {}

class MockGetFamilyMembersUseCase extends Mock
    implements GetFamilyMembersUseCase {}

class MockGetMemberTierUseCase extends Mock implements GetMemberTierUseCase {}

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

void main() {
  late PlanningViewModel viewModel;
  late MockGetCoursesUseCase mockGetCourses;
  late MockGetUserBookingsUseCase mockGetBookings;
  late MockGetFamilyMembersUseCase mockGetFamilyMembers;
  late MockGetMemberTierUseCase mockGetMemberTier;
  late MockGetUserProfileUseCase mockGetUserProfile;

  setUp(() {
    mockGetCourses = MockGetCoursesUseCase();
    mockGetBookings = MockGetUserBookingsUseCase();
    mockGetFamilyMembers = MockGetFamilyMembersUseCase();
    mockGetMemberTier = MockGetMemberTierUseCase();
    mockGetUserProfile = MockGetUserProfileUseCase();

    when(
      () => mockGetCourses.call(),
    ).thenAnswer((_) async => Result.success([]));
    when(
      () => mockGetBookings.call(),
    ).thenAnswer((_) async => Result.success([]));
    when(
      () => mockGetFamilyMembers.call(),
    ).thenAnswer((_) async => Result.success([]));
    when(() => mockGetUserProfile.call()).thenAnswer(
      (_) async => Result.failure(
        const ServerFailure(AppErrorCode.serverError, 'error'),
      ),
    );

    viewModel = PlanningViewModel(
      getCoursesUseCase: mockGetCourses,
      getUserBookingsUseCase: mockGetBookings,
      getFamilyMembersUseCase: mockGetFamilyMembers,
      getMemberTierUseCase: mockGetMemberTier,
      getUserProfileUseCase: mockGetUserProfile,
    );
  });

  group('PlanningViewModel', () {
    test('initial state loads successfully', () async {
      await Future.delayed(Duration.zero);
      check(viewModel.isLoading).isFalse();
    });
  });
}
