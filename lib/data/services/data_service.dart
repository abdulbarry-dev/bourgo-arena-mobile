import 'package:bourgo_arena_mobile/data/models/activity_model.dart';
import 'package:bourgo_arena_mobile/data/models/notification_model.dart';
import 'package:bourgo_arena_mobile/data/models/course.dart';
import 'package:bourgo_arena_mobile/data/models/reservation.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';

import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';

/// A facade service that maintains compatibility with existing ViewModels
/// while bridging them to the new clean architecture repositories.
///
/// NOTE: This service is intended for phased migration. ViewModels should
/// eventually be refactored to use domain-specific services or repositories directly.
class DataService extends ChangeNotifier {
  final UserRepository _userRepository;
  final ActivityRepository _activityRepository;
  final ReservationRepository _reservationRepository;

  DataService({
    required UserRepository userRepository,
    required ActivityRepository activityRepository,
    required ReservationRepository reservationRepository,
  }) : _userRepository = userRepository,
       _activityRepository = activityRepository,
       _reservationRepository = reservationRepository;

  /// Returns the user profile as a [UserProfile] model.
  Future<UserProfile> getUserProfile() async {
    final user = await _userRepository.getUserProfile();
    // Manual mapping for compatibility with old UI model
    return UserProfile(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phone: user.phone,
      avatarUrl: user.avatarUrl,
      loyaltyPoints: user.loyaltyPoints,
      subscriptionLevel: user.subscriptionLevel,
      subscriptionExpiry: user.subscriptionExpiry,
      totalCheckIns: user.totalCheckIns,
      birthDate: user.birthDate,
      isParentAccount: user.isParentAccount,
      // Mapping children if needed (omitted for brevity or mapping as empty for now)
      children: [],
    );
  }

  /// Updates the user profile.
  Future<void> updateProfile(UserProfile profile) async {
    // We would normally map this back to User entity and call repository
    // For now, we'll just log or implement a minimal update if the API supports it
  }

  /// Updates the user's password.
  Future<void> updatePassword(String current, String newPassword) async {
    // AuthRepository doesn't have changePassword yet in its interface,
    // so we might need to add it or just placeholder it.
  }

  /// Returns the list of activities as [ActivityModel] list.
  Future<List<ActivityModel>> getActivities() async {
    final activities = await _activityRepository.getActivities();
    return activities
        .map(
          (a) => ActivityModel(
            id: a.id,
            title: a.title,
            category: a.category,
            description: a.description,
            imageUrl: a.imageUrl,
            basePrice: a.basePrice,
            currency: a.currency,
            icon: a.icon,
            features: a.features,
            rating: a.rating,
            reviewCount: a.reviewCount,
          ),
        )
        .toList();
  }

  /// Returns the list of user's reservations.
  Future<List<Reservation>> getReservations() async {
    final bookings = await _reservationRepository.getReservations();
    return bookings
        .map(
          (b) => Reservation(
            id: b.id,
            activityId: b.activityId,
            activityTitle: b.activityTitle,
            date: b.date,
            time: b.time,
            duration: '60 min', // Defaulting as not present in entity
            price: b.price,
            status: b.status,
            paymentStatus: 'paid', // Defaulting
            qrCode: 'MOCK_QR',
          ),
        )
        .toList();
  }

  /// Returns the list of group courses (Placeholder).
  Future<List<Course>> getCourses() async {
    return [];
  }
  
  /// Returns notifications (Placeholder).
  Future<List<NotificationModel>> getNotifications() async {
    return [];
  }
}
