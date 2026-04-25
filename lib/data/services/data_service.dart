import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:bourgo_arena_mobile/data/models/activity.dart';
import 'package:bourgo_arena_mobile/data/models/course.dart';
import 'package:bourgo_arena_mobile/data/models/food_item.dart';
import 'package:bourgo_arena_mobile/data/models/notification_model.dart';
import 'package:bourgo_arena_mobile/data/models/reservation.dart';
import 'package:bourgo_arena_mobile/data/models/time_slot.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile.dart';

/// Service for loading mock data from assets.
class DataService {
  /// Loads the list of available activities.
  Future<List<Activity>> getActivities() async {
    final String response = await rootBundle.loadString(
      'assets/data/activities.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Activity.fromJson(json)).toList();
  }

  /// Loads the list of user reservations.
  Future<List<Reservation>> getReservations() async {
    final String response = await rootBundle.loadString(
      'assets/data/reservations.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Reservation.fromJson(json)).toList();
  }

  /// Loads available time slots for a given activity.
  Future<List<TimeSlot>> getTimeSlots(String activityId) async {
    final String response = await rootBundle.loadString(
      'assets/data/time_slots.json',
    );
    final Map<String, dynamic> data = json.decode(response);
    if (data.containsKey(activityId)) {
      final List<dynamic> slots = data[activityId];
      return slots.map((json) => TimeSlot.fromJson(json)).toList();
    }
    return [];
  }

  /// Loads the user's profile.
  Future<UserProfile> getUserProfile() async {
    final String response = await rootBundle.loadString(
      'assets/data/user_profile.json',
    );
    final dynamic data = json.decode(response);
    return UserProfile.fromJson(data);
  }

  /// Loads the list of group courses.
  Future<List<Course>> getCourses() async {
    final String response = await rootBundle.loadString(
      'assets/data/courses.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Course.fromJson(json)).toList();
  }

  /// Loads the list of user notifications.
  Future<List<NotificationModel>> getNotifications() async {
    final String response = await rootBundle.loadString(
      'assets/data/notifications.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  /// Fetches the list of food and drink items.
  Future<List<FoodItem>> getFoodMenu() async {
    final String response = await rootBundle.loadString(
      'assets/data/food_menu.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => FoodItem.fromJson(json)).toList();
  }
}
