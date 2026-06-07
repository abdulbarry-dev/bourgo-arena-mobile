import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/family_member.dart';
import 'package:bourgo_arena_mobile/domain/entities/member_tier.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_course_sessions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/enroll_in_course_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'dart:developer' as developer;

class PlanningEntry {
  final String id;
  final PlanningEntryType type;
  final String title;
  final String timeLabel;
  final int dayOfWeek;
  final Object source;
  final bool highlightForTier;

  const PlanningEntry({
    required this.id,
    required this.type,
    required this.title,
    required this.timeLabel,
    required this.dayOfWeek,
    required this.source,
    required this.highlightForTier,
  });
}

enum PlanningEntryType { course }

/// ViewModel for the Planning (Course Schedule) screen.
class PlanningViewModel extends BaseViewModel {
  final GetCoursesUseCase _getCoursesUseCase;
  final GetFamilyMembersUseCase _getFamilyMembersUseCase;
  final GetMemberTierUseCase _getMemberTierUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final GetActiveSubscriptionsUseCase _getActiveSubscriptionsUseCase;
  final GetCourseSessionsUseCase _getCourseSessionsUseCase;
  final EnrollInCourseUseCase _enrollInCourseUseCase;
  final AuthStateNotifier _authStateNotifier;

  List<Course> _allCourses = [];
  List<PlanningEntry> _unified = [];

  List<FamilyMember> _familyMembers = [];
  FamilyMember? _selectedMember;
  MemberTier _selectedMemberTier = MemberTier.public;
  bool _isLoading = false;
  int _selectedDay = 1; // Monday by default

  /// List of courses filtered by the selected day.
  List<Course> get courses => _coursesForDay();

  /// Unified feed of courses.
  List<PlanningEntry> get unified => _unified;

  List<FamilyMember> get familyMembers => _familyMembers;
  FamilyMember? get selectedMember => _selectedMember;
  MemberTier get selectedMemberTier => _selectedMemberTier;

  /// Whether data is currently being loaded.
  bool get isLoading => _isLoading;

  /// Currently selected day of the week (1-7).
  int get selectedDay => _selectedDay;

  /// Whether the user is authenticated.
  bool get isAuthenticated => _authStateNotifier.isAuthenticated;

  /// Whether the selected member has an active plan.
  bool get hasActivePlan => _selectedMemberTier != MemberTier.public;

  /// Creates a new [PlanningViewModel] instance.
  PlanningViewModel({
    required GetCoursesUseCase getCoursesUseCase,
    required GetFamilyMembersUseCase getFamilyMembersUseCase,
    required GetMemberTierUseCase getMemberTierUseCase,
    required GetUserProfileUseCase getUserProfileUseCase,
    required GetActiveSubscriptionsUseCase getActiveSubscriptionsUseCase,
    required GetCourseSessionsUseCase getCourseSessionsUseCase,
    required EnrollInCourseUseCase enrollInCourseUseCase,
    required AuthStateNotifier authStateNotifier,
  }) : _getCoursesUseCase = getCoursesUseCase,
       _getFamilyMembersUseCase = getFamilyMembersUseCase,
       _getMemberTierUseCase = getMemberTierUseCase,
       _getUserProfileUseCase = getUserProfileUseCase,
       _getActiveSubscriptionsUseCase = getActiveSubscriptionsUseCase,
       _getCourseSessionsUseCase = getCourseSessionsUseCase,
       _enrollInCourseUseCase = enrollInCourseUseCase,
       _authStateNotifier = authStateNotifier {
    loadPlanning();
  }

  /// Loads courses + family members for unified planning.
  Future<void> loadPlanning() async {
    developer.log('PlanningViewModel: loadPlanning() started');
    _isLoading = true;
    clearError();
    notifyListeners();

    final isAuthenticated = _authStateNotifier.isAuthenticated;

    try {
      final coursesResult = await _getCoursesUseCase();
      if (coursesResult is Success<List<Course>, Failure>) {
        _allCourses = coursesResult.data;
      } else {
        developer.log('PlanningViewModel: courses load failed');
        setErrorMessage('failed_to_load_courses');
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (isAuthenticated) {
        final familyResult = await _getFamilyMembersUseCase();
        if (familyResult is Success<List<FamilyMember>, Failure>) {
          _familyMembers = familyResult.data;
        } else {
          developer.log('PlanningViewModel: family load failed');
        }

        final profileResult = await _getUserProfileUseCase();
        if (profileResult is Success<User, Failure>) {
          _selectedMemberTier = _getMemberTierUseCase(
            subscriptionLevel: profileResult.data.subscriptionLevel,
          );
        } else {
          developer.log('PlanningViewModel: profile load failed');
        }
      } else {
        _selectedMemberTier = MemberTier.public;
      }

      _rebuildUnified();
    } catch (e, stack) {
      developer.log(
        'PlanningViewModel: Unexpected error: $e',
        error: e,
        stackTrace: stack,
      );
      setErrorMessage('unexpected_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _rebuildUnified() {
    final entries = <PlanningEntry>[];

    for (final course in _coursesForDay()) {
      entries.add(
        PlanningEntry(
          id: course.id,
          type: PlanningEntryType.course,
          title: course.title,
          timeLabel: '${course.startTime} - ${course.endTime}',
          dayOfWeek: course.dayOfWeek,
          source: course,
          highlightForTier: _isRecommendedForTier(course),
        ),
      );
    }

    entries.sort((a, b) => a.timeLabel.compareTo(b.timeLabel));
    _unified = entries;
  }

  bool _isRecommendedForTier(Course course) {
    if (_selectedMemberTier == MemberTier.ultra) return true;
    if (_selectedMemberTier == MemberTier.standard &&
        course.category == 'Fitness') {
      return true;
    }
    return false;
  }

  List<Course> _coursesForDay() {
    return _allCourses.where((c) => c.dayOfWeek == _selectedDay).toList();
  }

  void selectDay(int day) {
    _selectedDay = day;
    _rebuildUnified();
    notifyListeners();
  }

  void selectMember(FamilyMember? member) {
    _selectedMember = member;
    notifyListeners();
    // In a real app, this would refresh data filtered by that member
  }

  Future<bool> enrollInCourse(String courseId) async {
    final result = await _enrollInCourseUseCase(courseId);
    return result.when(
      success: (_) {
        // Refresh planning to show new reservation
        loadPlanning();
        return true;
      },
      failure: (f) {
        setErrorMessage('enrollment_failed');
        return false;
      },
    );
  }

  Future<Result<List<dynamic>, Failure>> getCourseSessions(String courseId) {
    return _getCourseSessionsUseCase(courseId);
  }
}
