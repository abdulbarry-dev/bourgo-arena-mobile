import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';

User testUserEntity({
  String id = 'user-1',
  String firstName = 'Alex',
  String lastName = 'Morgan',
  String email = 'alex@example.com',
  String phone = '+15550000000',
  String avatarUrl = 'https://example.com/avatar.png',
  int loyaltyPoints = 120,
  String subscriptionLevel = 'premium',
  DateTime? subscriptionExpiry,
  DateTime? birthDate,
  String? gender = 'male',
  bool isParentAccount = false,
  List<ChildProfile> children = const [],
}) {
  return User(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    phone: phone,
    avatarUrl: avatarUrl,
    loyaltyPoints: loyaltyPoints,
    subscriptionLevel: subscriptionLevel,
    subscriptionExpiry: subscriptionExpiry,
    birthDate: birthDate,
    gender: gender,
    isParentAccount: isParentAccount,
    children: children,
  );
}

AuthSession testAuthSession({
  User? user,
  AuthState state = AuthState.authenticated,
  String? token = 'token-123',
  String? pendingEmail,
}) {
  return AuthSession(
    user: user,
    state: state,
    token: token,
    pendingEmail: pendingEmail,
  );
}

ChildProfile testChildEntity({
  String id = 'child-1',
  String firstName = 'Mia',
  String lastName = 'Morgan',
  DateTime? birthDate,
  String? gender = 'female',
  String? avatarUrl = 'https://example.com/child.png',
}) {
  return ChildProfile(
    id: id,
    firstName: firstName,
    lastName: lastName,
    birthDate: birthDate ?? DateTime.utc(2016, 5, 8),
    gender: gender,
    avatarUrl: avatarUrl,
  );
}

Activity testActivityEntity({
  String id = 'activity-1',
  String title = 'Football',
  String category = 'Outdoor',
  double basePrice = 25.0,
  String currency = 'USD',
  String imageUrl = 'https://example.com/activity.png',
  String icon = 'sports_soccer',
  String description = 'Full field football session',
  List<String> features = const ['Indoor', 'Coached'],
  double rating = 4.8,
  int reviewCount = 42,
}) {
  return Activity(
    id: id,
    title: title,
    category: category,
    basePrice: basePrice,
    currency: currency,
    imageUrl: imageUrl,
    icon: icon,
    description: description,
    features: features,
    rating: rating,
    reviewCount: reviewCount,
  );
}

Course testCourseEntity({
  String id = 'course-1',
  String name = 'CrossFit Beginners',
  String title = 'CrossFit Beginners',
  String instructor = 'Coach Lee',
  String startTime = '18:00',
  String endTime = '19:30',
  int dayOfWeek = 1,
  String category = 'Fitness',
  int capacity = 20,
  int enrolled = 8,
  String icon = 'fitness_center',
}) {
  return Course(
    id: id,
    name: name,
    title: title,
    instructor: instructor,
    startTime: startTime,
    endTime: endTime,
    dayOfWeek: dayOfWeek,
    category: category,
    capacity: capacity,
    enrolled: enrolled,
    icon: icon,
  );
}

Service testServiceEntity({
  int id = 1,
  String name = 'Football Pitch',
  String description = 'Full size 11v11 pitch',
  String imageUrl = 'https://example.com/pitch.png',
}) {
  return Service(
    id: id,
    name: name,
    description: description,
    imageUrl: imageUrl,
  );
}

Notification testNotificationEntity({
  int id = 1,
  String title = 'Booking confirmed',
  String message = 'Your booking is confirmed.',
  DateTime? timestamp,
  String type = 'booking',
  bool isRead = false,
}) {
  return Notification(
    id: id,
    title: title,
    message: message,
    timestamp: timestamp ?? DateTime.utc(2026, 5, 8),
    type: type,
    isRead: isRead,
  );
}

Reservation testReservationEntity({
  String id = 'reservation-1',
  String activityId = 'activity-1',
  String activityTitle = 'Football',
  String date = '2026-05-08',
  String time = '18:00',
  String duration = '90 min',
  double price = 25.0,
  String status = 'confirmed',
  String paymentStatus = 'paid',
  String qrCode = 'QR-123456',
}) {
  return Reservation(
    id: id,
    activityId: activityId,
    activityTitle: activityTitle,
    date: date,
    time: time,
    duration: duration,
    price: price,
    status: status,
    paymentStatus: paymentStatus,
    qrCode: qrCode,
  );
}

TimeSlot testTimeSlotEntity({String time = '18:00', bool available = true}) {
  return TimeSlot(time: time, available: available);
}

Map<String, dynamic> testUserJson({
  String id = 'user-1',
  String name = 'Alex Morgan',
  String email = 'alex@example.com',
  String phone = '+15550000000',
  String? avatarUrl = 'https://example.com/avatar.png',
  int loyaltyPoints = 120,
  String subscriptionLevel = 'premium',
  String? subscriptionExpiry = '2026-12-31',
  DateTime? birthDate,
  String? gender = 'male',
  bool isParentAccount = false,
  List<Map<String, dynamic>> children = const [],
}) {
  return {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'avatar_url': avatarUrl,
    'loyalty_points': loyaltyPoints,
    'subscription_level': subscriptionLevel,
    'subscription_expiry': subscriptionExpiry,
    'birth_date': birthDate?.toIso8601String(),
    'gender': gender,
    'is_parent_account': isParentAccount,
    'children': children,
  };
}

Map<String, dynamic> testChildJson({
  String id = 'child-1',
  String firstName = 'Mia',
  String lastName = 'Morgan',
  DateTime? birthDate,
  String? gender = 'female',
  String? avatarUrl = 'https://example.com/child.png',
}) {
  return {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'birth_date': (birthDate ?? DateTime.utc(2016, 5, 8)).toIso8601String(),
    'gender': gender,
    'avatar_url': avatarUrl,
  };
}

Map<String, dynamic> testActivityJson({
  String id = 'activity-1',
  String title = 'Football',
  String category = 'Outdoor',
  double basePrice = 25.0,
  String currency = 'USD',
  String imageUrl = 'https://example.com/activity.png',
  String icon = 'sports_soccer',
  String description = 'Full field football session',
  List<String> features = const ['Indoor', 'Coached'],
  double rating = 4.8,
  int reviewCount = 42,
}) {
  return {
    'id': id,
    'title': title,
    'category': category,
    'base_price': basePrice,
    'currency': currency,
    'image_url': imageUrl,
    'icon': icon,
    'description': description,
    'features': features,
    'rating': rating,
    'review_count': reviewCount,
  };
}

Map<String, dynamic> testCourseJson({
  String id = 'course-1',
  String title = 'CrossFit Beginners',
  String instructor = 'Coach Lee',
  String startTime = '18:00',
  String endTime = '19:30',
  int dayOfWeek = 1,
  String category = 'Fitness',
  int capacity = 20,
  int enrolled = 8,
  String icon = 'fitness_center',
}) {
  return {
    'id': id,
    'title': title,
    'instructor': instructor,
    'start_time': startTime,
    'end_time': endTime,
    'day_of_week': dayOfWeek,
    'category': category,
    'capacity': capacity,
    'enrolled': enrolled,
    'icon': icon,
  };
}

Map<String, dynamic> testServiceJson({
  int id = 1,
  String name = 'Football Pitch',
  String description = 'Full size 11v11 pitch',
  String imageUrl = 'https://example.com/pitch.png',
}) {
  return {
    'id': id,
    'name': name,
    'description': description,
    'image_url': imageUrl,
  };
}

Map<String, dynamic> testNotificationJson({
  int id = 1,
  String title = 'Booking confirmed',
  String message = 'Your booking is confirmed.',
  String timestamp = '2026-05-08T10:30:00.000Z',
  String type = 'booking',
  bool isRead = false,
}) {
  return {
    'id': id,
    'title': title,
    'message': message,
    'timestamp': timestamp,
    'type': type,
    'is_read': isRead,
  };
}

Map<String, dynamic> testPaginatedNotificationsJson({
  required List<Map<String, dynamic>> data,
  int currentPage = 1,
  int lastPage = 1,
  int total = 1,
}) {
  return {
    'data': data,
    'links': {
      'first': 'https://example.com/notifications?page=1',
      'last': 'https://example.com/notifications?page=$lastPage',
      'prev': null,
      'next': currentPage < lastPage
          ? 'https://example.com/notifications?page=${currentPage + 1}'
          : null,
    },
    'meta': {
      'current_page': currentPage,
      'from': 1,
      'last_page': lastPage,
      'path': 'https://example.com/notifications',
      'per_page': 20,
      'to': data.length,
      'total': total,
    },
  };
}

Map<String, dynamic> testReservationJson({
  String id = 'reservation-1',
  String activityId = 'activity-1',
  String activityTitle = 'Football',
  String date = '2026-05-08',
  String time = '18:00',
  String duration = '90 min',
  double price = 25.0,
  String status = 'confirmed',
  String paymentStatus = 'paid',
  String qrCode = 'QR-123456',
}) {
  return {
    'id': id,
    'activity_id': activityId,
    'activity_title': activityTitle,
    'date': date,
    'time': time,
    'duration': duration,
    'price': price,
    'status': status,
    'payment_status': paymentStatus,
    'qr_code': qrCode,
  };
}

Map<String, dynamic> testTimeSlotJson({
  String time = '18:00',
  bool available = true,
}) {
  return {'time': time, 'available': available};
}

VerificationStatus testVerificationStatusEntity({
  bool emailVerified = false,
  bool phoneVerified = false,
  bool onboardingCompleted = false,
  bool? isFullyVerified,
  String? email = 'alex@example.com',
  String? phone = '+15550000000',
}) {
  return VerificationStatus(
    emailVerified: emailVerified,
    phoneVerified: phoneVerified,
    onboardingCompleted: onboardingCompleted,
    isFullyVerified: isFullyVerified,
    email: email,
    phone: phone,
  );
}

Map<String, dynamic> testVerificationStatusJson({
  bool emailVerified = false,
  bool phoneVerified = false,
  bool onboardingCompleted = false,
  bool? isFullyVerified,
  String? email = 'alex@example.com',
  String? phone = '+15550000000',
}) {
  return {
    'email_verified': emailVerified,
    'phone_verified': phoneVerified,
    'onboarding_completed': onboardingCompleted,
    'is_fully_verified': isFullyVerified,
    'email': email,
    'phone': phone,
  };
}
