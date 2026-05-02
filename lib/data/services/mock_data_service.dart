import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:bourgo_arena_mobile/data/models/activity.dart';
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
  Future<List<Activity>> getActivities() async {
    await Future.delayed(_latency);
    try {
      final String response = await rootBundle.loadString(
        'assets/data/activities.json',
      );
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Activity.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load activities: $e');
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
      return [];
    } catch (e) {
      throw Exception('Failed to load time slots: $e');
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
      throw Exception('Failed to load courses: $e');
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
    if (profile.name.isEmpty) {
      throw Exception('Name cannot be empty');
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
