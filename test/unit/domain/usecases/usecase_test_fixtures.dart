import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';

User testUser({
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
    isParentAccount: isParentAccount,
    children: children,
  );
}

Activity testActivity({
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

Course testCourse({
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

Reservation testReservation({
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

Notification testNotification({
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

TimeSlot testTimeSlot({String time = '18:00', bool available = true}) {
  return TimeSlot(time: time, available: available);
}
