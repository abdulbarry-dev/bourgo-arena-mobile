import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_course_sessions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/enroll_in_course_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockGetCoursesUseCase extends Mock implements GetCoursesUseCase {}

class MockGetFamilyMembersUseCase extends Mock
    implements GetFamilyMembersUseCase {}

class MockGetMemberTierUseCase extends Mock implements GetMemberTierUseCase {}

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

class MockGetActiveSubscriptionsUseCase extends Mock
    implements GetActiveSubscriptionsUseCase {}

class MockGetCourseSessionsUseCase extends Mock
    implements GetCourseSessionsUseCase {}

class MockEnrollInCourseUseCase extends Mock implements EnrollInCourseUseCase {}

void main() {
  late PlanningViewModel viewModel;
  late MockGetCoursesUseCase mockGetCourses;
  late MockGetFamilyMembersUseCase mockGetFamilyMembers;
  late MockGetMemberTierUseCase mockGetMemberTier;
  late MockGetUserProfileUseCase mockGetUserProfile;
  late MockAuthStateNotifier mockAuthStateNotifier;
  late MockGetActiveSubscriptionsUseCase mockGetActiveSubscriptions;
  late MockGetCourseSessionsUseCase mockGetCourseSessions;
  late MockEnrollInCourseUseCase mockEnrollInCourseUseCase;

  setUp(() {
    mockGetCourses = MockGetCoursesUseCase();
    mockGetFamilyMembers = MockGetFamilyMembersUseCase();
    mockGetMemberTier = MockGetMemberTierUseCase();
    mockGetUserProfile = MockGetUserProfileUseCase();
    mockAuthStateNotifier = MockAuthStateNotifier();
    mockGetActiveSubscriptions = MockGetActiveSubscriptionsUseCase();
    mockGetCourseSessions = MockGetCourseSessionsUseCase();
    mockEnrollInCourseUseCase = MockEnrollInCourseUseCase();

    when(() => mockAuthStateNotifier.isAuthenticated).thenReturn(true);

    when(
      () => mockGetCourses.call(),
    ).thenAnswer((_) async => Result.success([]));
    when(
      () => mockGetFamilyMembers.call(),
    ).thenAnswer((_) async => Result.success([]));
    when(() => mockGetUserProfile.call()).thenAnswer(
      (_) async => Result.failure(
        const ServerFailure(AppErrorCode.serverError, 'error'),
      ),
    );
    when(
      () => mockGetActiveSubscriptions.execute(),
    ).thenAnswer((_) async => Result.success([]));

    viewModel = PlanningViewModel(
      getCoursesUseCase: mockGetCourses,
      getFamilyMembersUseCase: mockGetFamilyMembers,
      getMemberTierUseCase: mockGetMemberTier,
      getUserProfileUseCase: mockGetUserProfile,
      authStateNotifier: mockAuthStateNotifier,
      getActiveSubscriptionsUseCase: mockGetActiveSubscriptions,
      getCourseSessionsUseCase: mockGetCourseSessions,
      enrollInCourseUseCase: mockEnrollInCourseUseCase,
    );
  });

  group('PlanningViewModel', () {
    test('initial state loads successfully', () async {
      await Future.delayed(Duration.zero);
      check(viewModel.isLoading).isFalse();
    });
  });
}
