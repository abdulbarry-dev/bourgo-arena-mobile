import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_course_sessions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/enroll_in_course_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_services_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockGetCoursesUseCase extends Mock implements GetCoursesUseCase {}

class MockGetCourseSessionsUseCase extends Mock
    implements GetCourseSessionsUseCase {}

class MockGetFamilyMembersUseCase extends Mock
    implements GetFamilyMembersUseCase {}

class MockGetMemberTierUseCase extends Mock implements GetMemberTierUseCase {}

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

class MockBookCourseSessionUseCase extends Mock
    implements BookCourseSessionUseCase {}

class MockGetActiveSubscriptionsUseCase extends Mock
    implements GetActiveSubscriptionsUseCase {}

class MockGetServicesUseCase extends Mock implements GetServicesUseCase {}

void main() {
  late PlanningViewModel viewModel;
  late MockGetCoursesUseCase mockGetCourses;
  late MockGetCourseSessionsUseCase mockGetCourseSessions;
  late MockGetFamilyMembersUseCase mockGetFamilyMembers;
  late MockGetMemberTierUseCase mockGetMemberTier;
  late MockGetUserProfileUseCase mockGetUserProfile;
  late MockAuthStateNotifier mockAuthStateNotifier;
  late MockBookCourseSessionUseCase mockBookSession;
  late MockGetActiveSubscriptionsUseCase mockGetActiveSubs;
  late MockGetServicesUseCase mockGetServices;

  setUp(() {
    mockGetCourses = MockGetCoursesUseCase();
    mockGetCourseSessions = MockGetCourseSessionsUseCase();
    mockGetFamilyMembers = MockGetFamilyMembersUseCase();
    mockGetMemberTier = MockGetMemberTierUseCase();
    mockGetUserProfile = MockGetUserProfileUseCase();
    mockAuthStateNotifier = MockAuthStateNotifier();
    mockBookSession = MockBookCourseSessionUseCase();
    mockGetActiveSubs = MockGetActiveSubscriptionsUseCase();
    mockGetServices = MockGetServicesUseCase();

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
      () => mockGetServices.call(),
    ).thenAnswer((_) async => Result.success(<Service>[]));
    when(
      () => mockGetActiveSubs.execute(),
    ).thenAnswer((_) async => Result.success(<Subscription>[]));

    viewModel = PlanningViewModel(
      getCoursesUseCase: mockGetCourses,
      getCourseSessionsUseCase: mockGetCourseSessions,
      getFamilyMembersUseCase: mockGetFamilyMembers,
      getMemberTierUseCase: mockGetMemberTier,
      getUserProfileUseCase: mockGetUserProfile,
      authStateNotifier: mockAuthStateNotifier,
      bookSessionUseCase: mockBookSession,
      getActiveSubscriptionsUseCase: mockGetActiveSubs,
      getServicesUseCase: mockGetServices,
    );
  });

  group('PlanningViewModel', () {
    test('initial state loads successfully', () async {
      await Future.delayed(Duration.zero);
      check(viewModel.isLoading).isFalse();
    });
  });
}
