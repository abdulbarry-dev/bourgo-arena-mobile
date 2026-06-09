import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final int id;
  final String name;
  final String? imageUrl;
  final String? description;
  final int plansCount;
  final int coursesCount;
  final int eventsCount;
  final int activitiesCount;
  final List<Plan> plans;
  final List<Course> courses;
  final List<Event> events;
  final List<Activity> activities;

  const Service({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
    this.plansCount = 0,
    this.coursesCount = 0,
    this.eventsCount = 0,
    this.activitiesCount = 0,
    this.plans = const [],
    this.courses = const [],
    this.events = const [],
    this.activities = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    description,
    plansCount,
    coursesCount,
    eventsCount,
    activitiesCount,
    plans,
    courses,
    events,
    activities,
  ];
}
