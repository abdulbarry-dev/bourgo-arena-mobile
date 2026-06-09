import 'package:equatable/equatable.dart';

/// Entity for a plan's nested service.
class PlanService extends Equatable {
  final String id;
  final String? name;
  final String? slug;
  final String? description;
  final String? imageUrl;
  final List<String>? images;
  final String? status;

  const PlanService({
    required this.id,
    this.name,
    this.slug,
    this.description,
    this.imageUrl,
    this.images,
    this.status,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    imageUrl,
    images,
    status,
  ];
}

/// Entity representing a subscription plan matching PlanResource.
class Plan extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;

  /// Duration in days.
  final int? durationDays;

  /// Legacy billing cycle string kept for display compatibility.
  final String? billingCycle;

  /// Whether this plan grants access to all courses.
  final bool hasAllCourses;

  /// Nested service entity.
  final PlanService? service;

  const Plan({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.durationDays,
    this.billingCycle,
    this.hasAllCourses = false,
    this.service,
  });

  /// Returns service image URL if available.
  String? get serviceImageUrl => service?.imageUrl;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    durationDays,
    billingCycle,
    hasAllCourses,
    service,
  ];
}
