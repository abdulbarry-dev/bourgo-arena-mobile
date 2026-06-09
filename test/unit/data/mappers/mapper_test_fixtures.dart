import 'package:bourgo_arena_mobile/data/models/activity_model.dart';
import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:bourgo_arena_mobile/data/models/course_model.dart';
import 'package:bourgo_arena_mobile/data/models/notification_model.dart';
import 'package:bourgo_arena_mobile/data/models/reservation_model.dart';
import 'package:bourgo_arena_mobile/data/models/time_slot_model.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile_model.dart';

ChildProfileModel testChildProfileModel({
  String id = 'child-1',
  String firstName = 'Mia',
  String lastName = 'Morgan',
  DateTime? birthDate,
  String? gender = 'female',
  String? avatarUrl = 'https://example.com/child.png',
}) {
  return ChildProfileModel(
    id: id,
    firstName: firstName,
    lastName: lastName,
    birthDate: birthDate ?? DateTime.utc(2016, 5, 8),
    gender: gender,
    avatarUrl: avatarUrl,
  );
}

UserProfileModel testUserProfileModel({
  String id = 'user-1',
  String name = 'Alex Morgan',
  String email = 'alex@example.com',
  String phone = '+15550000000',
  String? avatarUrl = 'https://example.com/avatar.png',
  int loyaltyPoints = 120,
  String subscriptionLevel = 'premium',
  DateTime? subscriptionExpiry,
  DateTime? birthDate,
  bool isParentAccount = false,
  List<ChildProfileModel> children = const [],
}) {
  return UserProfileModel(
    id: id,
    name: name,
    email: email,
    phone: phone,
    avatarUrl: avatarUrl,
    loyaltyPoints: loyaltyPoints,
    subscriptionLevel: subscriptionLevel,
    subscriptionExpiry: subscriptionExpiry,
    birthDate: birthDate,
    isParentAccount: isParentAccount,
    children: children,
  );
}

ActivityModel testActivityModel({
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
  return ActivityModel(
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

CourseModel testCourseModel({
  String id = 'course-1',
  String? name,
  String? title,
  String? description,
  String? status,
  List<String>? images,
  String? imageUrl,
  String? instructor,
  String? startTime,
  String? endTime,
  int? dayOfWeek,
  String? category,
  int? capacity,
  int? enrolled,
  String? icon,
}) {
  return CourseModel(
    id: id,
    name: name ?? 'CrossFit Beginners',
    title: title,
    description: description ?? 'Introductory CrossFit class',
    status: status ?? 'active',
    images: images ?? ['https://example.com/course.jpg'],
    imageUrl: imageUrl ?? 'https://example.com/course.jpg',
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

NotificationModel testNotificationModel({
  int id = 1,
  String title = 'Booking confirmed',
  String message = 'Your booking is confirmed.',
  String timestamp = '2026-05-08T10:30:00.000Z',
  String type = 'booking',
  bool isRead = false,
}) {
  return NotificationModel(
    id: id,
    title: title,
    message: message,
    timestamp: timestamp,
    type: type,
    isRead: isRead,
  );
}

ReservationModel testReservationModel({
  String id = 'reservation-1',
  String activityId = 'activity-1',
  String activityTitle = 'Football',
  String? memberId = 'member-1',
  String date = '2026-05-08',
  String time = '18:00',
  String duration = '90 min',
  double price = 25.0,
  String status = 'confirmed',
  String paymentStatus = 'paid',
  String qrCode = 'QR-123456',
}) {
  return ReservationModel(
    id: id,
    activityId: activityId,
    activityTitle: activityTitle,
    memberId: memberId,
    date: date,
    time: time,
    duration: duration,
    price: price,
    status: status,
    paymentStatus: paymentStatus,
    qrCode: qrCode,
  );
}

TimeSlotModel testTimeSlotModel({
  String time = '18:00',
  bool available = true,
}) {
  return TimeSlotModel(time: time, available: available);
}
