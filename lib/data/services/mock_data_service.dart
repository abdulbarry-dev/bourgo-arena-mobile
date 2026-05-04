import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:bourgo_arena_mobile/data/models/activity_model.dart';
import 'package:bourgo_arena_mobile/data/models/course.dart';
import 'package:bourgo_arena_mobile/data/models/notification_model.dart';
import 'package:bourgo_arena_mobile/data/models/reservation.dart';
import 'package:bourgo_arena_mobile/data/models/time_slot.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';

/// Implementation of [DataService] that loads data from local assets.
/// Simulates network latency and potential errors.
class MockDataService implements DataService {
  static const Duration _latency = Duration(milliseconds: 800);

  @override
  Future<List<ActivityModel>> getActivities() async {
    await Future.delayed(_latency);
    try {
      final String response = await rootBundle.loadString(
        'assets/data/activities.json',
      );
      final List<dynamic> data = json.decode(response);
      return data.map((json) => ActivityModel.fromJson(json)).toList();
    } catch (e) {
      // Fallback data if JSON loading fails
      return [
        const ActivityModel(
          id: 'foot-1',
          title: 'Football 5x5',
          category: 'Outdoor',
          price: 80.0,
          currency: 'TND',
          imageUrl:
              'https://images.unsplash.com/photo-1544441892-794166f42a7b?q=80&w=800&auto=format&fit=crop',
          icon: 'sports_soccer',
          description:
              'Premium synthetic turf for the best football experience.',
          features: ['Floodlights', 'Changing rooms'],
        ),
        const ActivityModel(
          id: 'padel-1',
          title: 'Padel Court',
          category: 'Racket',
          price: 120.0,
          currency: 'TND',
          imageUrl:
              'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=800&auto=format&fit=crop',
          icon: 'sports_tennis',
          description: 'High-quality panoramic padel courts.',
          features: ['Pro equipment', 'Scoreboard'],
        ),
      ];
    }
  }

  @override
  Future<List<Reservation>> getReservations() async {
    await Future.delayed(_latency);
    try {
      final String response = await rootBundle.loadString(
        'assets/data/reservations.json',
      );
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Reservation.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load reservations: $e');
    }
  }

  @override
  Future<List<TimeSlot>> getTimeSlots(String activityId) async {
    await Future.delayed(_latency);
    try {
      final String response = await rootBundle.loadString(
        'assets/data/time_slots.json',
      );
      final Map<String, dynamic> data = json.decode(response);
      if (data.containsKey(activityId)) {
        final List<dynamic> slots = data[activityId];
        return slots.map((json) => TimeSlot.fromJson(json)).toList();
      }
      developer.log(
        'MockDataService: Activity $activityId not found in time_slots.json, returning generic slots',
      );
      // If activity not found in JSON, return generic slots
      return [
        const TimeSlot(time: '09:00', available: true),
        const TimeSlot(time: '10:30', available: true),
        const TimeSlot(time: '12:00', available: true),
        const TimeSlot(time: '15:00', available: true),
        const TimeSlot(time: '16:30', available: true),
        const TimeSlot(time: '18:00', available: true),
        const TimeSlot(time: '19:30', available: true),
        const TimeSlot(time: '21:00', available: true),
      ];
    } catch (e) {
      developer.log(
        'MockDataService: Error loading time slots for $activityId: $e',
      );
      // Fallback data if JSON loading fails or activity not found
      return [
        const TimeSlot(time: '09:00', available: true),
        const TimeSlot(time: '10:00', available: true),
        const TimeSlot(time: '11:00', available: false),
        const TimeSlot(time: '14:00', available: true),
        const TimeSlot(time: '15:00', available: true),
        const TimeSlot(time: '16:00', available: true),
        const TimeSlot(time: '17:00', available: true),
        const TimeSlot(time: '18:00', available: true),
      ];
    }
  }

  @override
  Future<UserProfile> getUserProfile() async {
    await Future.delayed(_latency);
    try {
      final String response = await rootBundle.loadString(
        'assets/data/user_profile.json',
      );
      final dynamic data = json.decode(response);
      return UserProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    }
  }

  @override
  Future<List<Course>> getCourses() async {
    await Future.delayed(_latency);
    try {
      final String response = await rootBundle.loadString(
        'assets/data/courses.json',
      );
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Course.fromJson(json)).toList();
    } catch (e) {
      // Fallback data if JSON loading fails
      return [
        Course(
          id: 'course-f1',
          title: 'CrossFit Pro',
          instructor: 'Coach Sami',
          startTime: '18:00',
          endTime: '19:00',
          dayOfWeek: DateTime.now().weekday,
          category: 'Fitness',
          capacity: 15,
          enrolled: 12,
          icon: 'fitness_center',
        ),
        Course(
          id: 'course-f2',
          title: 'Yoga Flow',
          instructor: 'Ines',
          startTime: '09:00',
          endTime: '10:15',
          dayOfWeek: DateTime.now().weekday,
          category: 'Wellness',
          capacity: 10,
          enrolled: 10,
          icon: 'self_improvement',
        ),
      ];
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(_latency);
    try {
      final String response = await rootBundle.loadString(
        'assets/data/notifications.json',
      );
      final List<dynamic> data = json.decode(response);
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate potential server error
    if (profile.firstName.isEmpty || profile.lastName.isEmpty) {
      throw Exception('First and last name cannot be empty');
    }
  }

  @override
  Future<void> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate validation
    if (currentPassword != 'password123') {
      throw Exception('Incorrect current password');
    }
  }
}
