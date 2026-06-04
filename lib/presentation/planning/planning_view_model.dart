import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/family_member.dart';
import 'package:bourgo_arena_mobile/domain/entities/member_tier.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
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

enum PlanningEntryType { course, reservation }

/// ViewModel for the Planning (Course Schedule) screen.
class PlanningViewModel extends BaseViewModel {
  final GetCoursesUseCase _getCoursesUseCase;
  final GetUserBookingsUseCase _getUserBookingsUseCase;
  final GetFamilyMembersUseCase _getFamilyMembersUseCase;
  final GetMemberTierUseCase _getMemberTierUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;

  List<Course> _allCourses = [];
  List<Reservation> _allReservations = [];
  List<PlanningEntry> _unified = [];

  List<FamilyMember> _familyMembers = [];
  FamilyMember? _selectedMember;
  MemberTier _selectedMemberTier = MemberTier.public;
  bool _isLoading = false;
  int _selectedDay = 1; // Monday by default

  /// List of courses filtered by the selected day.
  List<Course> get courses => _coursesForDay();

  /// List of reservations filtered by selected day.
  List<Reservation> get reservations => _reservationsForDay();

  /// Unified feed of courses + reservations.
  List<PlanningEntry> get unified => _unified;

  List<FamilyMember> get familyMembers => _familyMembers;
  FamilyMember? get selectedMember => _selectedMember;
  MemberTier get selectedMemberTier => _selectedMemberTier;

  /// Whether data is currently being loaded.
  bool get isLoading => _isLoading;

  /// Currently selected day of the week (1-7).
  int get selectedDay => _selectedDay;

  /// Creates a new [PlanningViewModel] instance.
  PlanningViewModel({
    required GetCoursesUseCase getCoursesUseCase,
    required GetUserBookingsUseCase getUserBookingsUseCase,
    required GetFamilyMembersUseCase getFamilyMembersUseCase,
    required GetMemberTierUseCase getMemberTierUseCase,
    required GetUserProfileUseCase getUserProfileUseCase,
  }) : _getCoursesUseCase = getCoursesUseCase,
       _getUserBookingsUseCase = getUserBookingsUseCase,
       _getFamilyMembersUseCase = getFamilyMembersUseCase,
       _getMemberTierUseCase = getMemberTierUseCase,
       _getUserProfileUseCase = getUserProfileUseCase {
    loadPlanning();
  }

  /// Loads courses + reservations + family members for unified planning.
  Future<void> loadPlanning() async {
    developer.log('PlanningViewModel: loadPlanning() started');
    _isLoading = true;
    clearError();
    notifyListeners();

    try {
      final results = await Future.wait([
        _getCoursesUseCase(),
        _getUserBookingsUseCase(),
        _getFamilyMembersUseCase(),
        _getUserProfileUseCase(),
      ]);

      final coursesResult = results[0] as Result<List<Course>, Failure>;
      final bookingsResult = results[1] as Result<List<Reservation>, Failure>;
      final membersResult = results[2] as Result<List<FamilyMember>, Failure>;
      final userResult = results[3] as Result<User, Failure>;

      coursesResult.when(
        success: (data) {
          developer.log('PlanningViewModel: Successfully loaded ${data.length} courses');
          _allCourses = data;
        },
        failure: (failure) {
          developer.log('PlanningViewModel: Failed to load courses - ${failure.message}');
          setErrorMessage(failure.message);
          _allCourses = [];
        },
      );

      bookingsResult.when(
        success: (data) {
          developer.log('PlanningViewModel: Successfully loaded ${data.length} bookings');
          _allReservations = data;
        },
        failure: (failure) {
          developer.log('PlanningViewModel: Failed to load bookings - ${failure.message}');
          _allReservations = [];
        },
      );

      membersResult.when(
        success: (members) {
          developer.log('PlanningViewModel: Successfully loaded ${members.length} family members');
          _familyMembers = members;
          _selectedMember ??= members.isNotEmpty ? members.first : null;
        },
        failure: (failure) {
          developer.log('PlanningViewModel: Failed to load family members - ${failure.message}');
          _familyMembers = [];
          _selectedMember = null;
        },
      );

      userResult.when(
        success: (user) {
          developer.log('PlanningViewModel: Successfully loaded user profile');
          _selectedMemberTier = _getMemberTierUseCase(
            subscriptionLevel: user.subscriptionLevel,
          );
        },
        failure: (failure) {
          developer.log('PlanningViewModel: Failed to load user profile - ${failure.message}');
          _selectedMemberTier = MemberTier.public;
        },
      );

      _buildUnified();
      developer.log('PlanningViewModel: data loaded, unified length=${_unified.length}');
    } catch (e, stack) {
      developer.log('PlanningViewModel: Error loading planning data: $e', error: e, stackTrace: stack);
      setErrorMessage(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates the selected day and refreshes the data.
  void selectDay(int day) {
    _selectedDay = day;
    notifyListeners();
  }

  void selectMember(FamilyMember member) {
    _selectedMember = member;
    notifyListeners();
  }

  List<Course> _coursesForDay() {
    return _allCourses.where((course) {
      return course.dayOfWeek == _selectedDay;
    }).toList();
  }

  List<Reservation> _reservationsForDay() {
    return _allReservations.where((reservation) {
      try {
        final date = DateTime.parse(reservation.date);
        return date.weekday == _selectedDay;
      } catch (_) {
        return false;
      }
    }).toList();
  }

  void _buildUnified() {
    final courses = _coursesForDay();
    final reservations = _reservationsForDay();

    final merged = <PlanningEntry>[
      ...courses.map(
        (c) => PlanningEntry(
          id: c.id,
          type: PlanningEntryType.course,
          title: c.title,
          timeLabel: '${c.startTime}–${c.endTime}',
          dayOfWeek: c.dayOfWeek,
          source: c,
          highlightForTier: _selectedMemberTier.rank >= MemberTier.ultra.rank,
        ),
      ),
      ...reservations.map(
        (r) => PlanningEntry(
          id: r.id,
          type: PlanningEntryType.reservation,
          title: r.activityTitle,
          timeLabel: r.time,
          dayOfWeek: _selectedDay,
          source: r,
          highlightForTier:
              _selectedMemberTier.rank >= MemberTier.standard.rank,
        ),
      ),
    ];

    merged.sort((a, b) => a.timeLabel.compareTo(b.timeLabel));
    _unified = merged;
  }
}
