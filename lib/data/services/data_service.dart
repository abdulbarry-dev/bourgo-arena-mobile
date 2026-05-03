import 'package:bourgo_arena_mobile/data/models/activity_model.dart';
import 'package:bourgo_arena_mobile/data/models/course.dart';
import 'package:bourgo_arena_mobile/data/models/notification_model.dart';
import 'package:bourgo_arena_mobile/data/models/reservation.dart';
import 'package:bourgo_arena_mobile/data/models/time_slot.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile.dart';
import 'package:bourgo_arena_mobile/data/services/mock_data_service.dart';

/// Abstract interface for the application data service.
/// This allows switching between Mock and Real API implementations.
abstract class DataService {
  /// Factory constructor to return the appropriate implementation.
  /// Set [useMock] to false to use the real API implementation (when available).
  factory DataService({bool useMock = true}) {
    if (useMock) {
      return MockDataService();
    }
    // Fallback to mock for now as real API is not implemented
    return MockDataService();
  }

  /// Loads the list of available activities.
  Future<List<ActivityModel>> getActivities();

  /// Loads the list of user reservations.
  Future<List<Reservation>> getReservations();

  /// Loads available time slots for a given activity.
  Future<List<TimeSlot>> getTimeSlots(String activityId);

  /// Loads the user's profile.
  Future<UserProfile> getUserProfile();

  /// Loads the list of group courses.
  Future<List<Course>> getCourses();

  /// Loads the list of user notifications.
  Future<List<NotificationModel>> getNotifications();

  /// Updates the user's profile.
  Future<void> updateProfile(UserProfile profile);

  /// Updates the user's password.
  Future<void> updatePassword(String currentPassword, String newPassword);
}
