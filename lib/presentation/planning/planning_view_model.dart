import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/family_member.dart';
import 'package:bourgo_arena_mobile/domain/entities/member_tier.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_course_sessions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/enroll_in_course_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'dart:developer' as developer;

class PlanningEntry {
  final String id;
  final String title;
  final String? imageUrl;
  final String? description;
  final String? status;
  final Course source;
  final String courseId;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final int capacity;
  final int enrolled;
  final bool isFull;
  final bool isBooked;

  const PlanningEntry({
    required this.id,
    required this.title,
    this.imageUrl,
    this.description,
    this.status,
    required this.source,
    required this.courseId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.enrolled,
    required this.isFull,
    this.isBooked = false,
  });

  String get formattedTime => '$startTime - $endTime';
}

class PlanningViewModel extends BaseViewModel {
  static const Map<int, String> dayNames = {
    0: 'DIMANCHE',
    1: 'LUNDI',
    2: 'MARDI',
    3: 'MERCREDI',
    4: 'JEUDI',
    5: 'VENDREDI',
    6: 'SAMEDI',
  };

  final GetCoursesUseCase _getCoursesUseCase;
  final GetCourseSessionsUseCase _getCourseSessionsUseCase;
  final GetFamilyMembersUseCase _getFamilyMembersUseCase;
  final GetMemberTierUseCase _getMemberTierUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final BookCourseSessionUseCase _bookSessionUseCase;
  final AuthStateNotifier _authStateNotifier;

  List<Course> _allCourses = [];
  List<PlanningEntry> _allSessions = [];
  Map<int, List<PlanningEntry>> _sessionsByDay = {};

  List<FamilyMember> _familyMembers = [];
  FamilyMember? _selectedMember;
  MemberTier _selectedMemberTier = MemberTier.public;
  bool _isLoading = false;
  bool _isSubscriptionGate = false;

  List<Course> get courses => _allCourses;
  List<PlanningEntry> get allSessions => _allSessions;
  Map<int, List<PlanningEntry>> get sessionsByDay => _sessionsByDay;
  List<int> get availableDays => _sessionsByDay.keys.toList()..sort();

  List<FamilyMember> get familyMembers => _familyMembers;
  FamilyMember? get selectedMember => _selectedMember;
  MemberTier get selectedMemberTier => _selectedMemberTier;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _authStateNotifier.isAuthenticated;
  bool get hasActivePlan => _selectedMemberTier != MemberTier.public;
  bool get isSubscriptionGate => _isSubscriptionGate;
  bool get hasSessions => _allSessions.isNotEmpty;

  PlanningViewModel({
    required GetCoursesUseCase getCoursesUseCase,
    required GetCourseSessionsUseCase getCourseSessionsUseCase,
    required GetFamilyMembersUseCase getFamilyMembersUseCase,
    required GetMemberTierUseCase getMemberTierUseCase,
    required GetUserProfileUseCase getUserProfileUseCase,
    required BookCourseSessionUseCase bookSessionUseCase,
    required AuthStateNotifier authStateNotifier,
  }) : _getCoursesUseCase = getCoursesUseCase,
       _getCourseSessionsUseCase = getCourseSessionsUseCase,
       _getFamilyMembersUseCase = getFamilyMembersUseCase,
       _getMemberTierUseCase = getMemberTierUseCase,
       _getUserProfileUseCase = getUserProfileUseCase,
       _bookSessionUseCase = bookSessionUseCase,
       _authStateNotifier = authStateNotifier;

  Future<void> loadPlanning() async {
    _isLoading = true;
    clearError();
    notifyListeners();

    try {
      final result = await _getCoursesUseCase();
      result.when(
        success: (courses) => _allCourses = courses,
        failure: (f) => setErrorMessage(f.message),
      );

      if (_authStateNotifier.isAuthenticated) {
        await _loadFamilyContext();
        await _loadAllCourseSessions();
      } else {
        _selectedMemberTier = MemberTier.public;
        _isSubscriptionGate = true;
      }
    } catch (e, stack) {
      developer.log('PlanningViewModel: $e', error: e, stackTrace: stack);
      setErrorMessage('loading_failed');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadAllCourseSessions() async {
    if (_allCourses.isEmpty) return;

    final futures = _allCourses.map(
      (c) => _getCourseSessionsUseCase(c.id),
    );
    final results = await Future.wait(futures);

    final entries = <PlanningEntry>[];
    for (int i = 0; i < results.length; i++) {
      results[i].when(
        success: (sessions) {
          if (sessions.isEmpty) return;
          final course = _allCourses[i];
          for (final session in sessions) {
            entries.add(PlanningEntry(
              id: session.id,
              title: session.title,
              imageUrl:
                  session.imageUrl ??
                  course.imageUrl ??
                  (course.images.isNotEmpty ? course.images.first : null),
              description: null,
              status: course.status,
              source: course,
              courseId: course.id,
              dayOfWeek: session.dayOfWeek,
              startTime: session.startTime,
              endTime: session.endTime,
              capacity: session.capacity,
              enrolled: session.enrolled,
              isFull: session.isFull,
              isBooked: session.isBooked,
            ));
          }
        },
        failure: (f) {
          developer.log(
            'Skipping course ${_allCourses[i].id}: ${f.message}',
          );
        },
      );
    }

    _allSessions = entries;
    _allSessions.sort((a, b) {
      final dayCmp = a.dayOfWeek.compareTo(b.dayOfWeek);
      if (dayCmp != 0) return dayCmp;
      return a.startTime.compareTo(b.startTime);
    });

    _sessionsByDay = {};
    for (final entry in _allSessions) {
      _sessionsByDay.putIfAbsent(entry.dayOfWeek, () => []).add(entry);
    }

    _isSubscriptionGate = _allSessions.isEmpty;
  }

  Future<void> _loadFamilyContext() async {
    final membersResult = await _getFamilyMembersUseCase();
    membersResult.when(
      success: (members) => _familyMembers = members,
      failure: (_) => developer.log('Failed to load family members'),
    );

    final profileResult = await _getUserProfileUseCase();
    profileResult.when(
      success: (user) {
        _selectedMemberTier = _getMemberTierUseCase(
          subscriptionLevel: user.subscriptionLevel,
        );
      },
      failure: (_) => _selectedMemberTier = MemberTier.public,
    );
  }

  void selectMember(FamilyMember? member) {
    _selectedMember = member;
    notifyListeners();
  }

  Future<String?> bookSession(String courseId, String sessionId, String date) async {
    final result = await _bookSessionUseCase(courseId, sessionId, date);
    return result.when(
      success: (_) {
        _incrementEnrolled(sessionId);
        return null;
      },
      failure: (f) => f.message,
    );
  }

  void _incrementEnrolled(String sessionId) {
    final index = _allSessions.indexWhere((s) => s.id == sessionId);
    if (index == -1) return;
    final old = _allSessions[index];
    final updated = PlanningEntry(
      id: old.id,
      title: old.title,
      imageUrl: old.imageUrl,
      description: old.description,
      status: old.status,
      source: old.source,
      courseId: old.courseId,
      dayOfWeek: old.dayOfWeek,
      startTime: old.startTime,
      endTime: old.endTime,
      capacity: old.capacity,
      enrolled: old.enrolled + 1,
      isFull: old.enrolled + 1 >= old.capacity,
      isBooked: true,
    );
    _allSessions[index] = updated;
    final dayList = _sessionsByDay[old.dayOfWeek];
    if (dayList != null) {
      final dayIdx = dayList.indexWhere((s) => s.id == sessionId);
      if (dayIdx != -1) {
        dayList[dayIdx] = updated;
      }
    }
    notifyListeners();
  }
}
