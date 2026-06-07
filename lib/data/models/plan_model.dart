import 'package:json_annotation/json_annotation.dart';

part 'plan_model.g.dart';

/// DTO for a nested service within a plan.
@JsonSerializable(fieldRename: FieldRename.snake)
class PlanServiceModel {
  final String id;
  final String? name;
  final String? slug;
  final String? description;
  final String? imageUrl;
  final String? status;

  const PlanServiceModel({
    required this.id,
    this.name,
    this.slug,
    this.description,
    this.imageUrl,
    this.status,
  });

  factory PlanServiceModel.fromJson(Map<String, dynamic> json) =>
      _$PlanServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlanServiceModelToJson(this);
}

/// DTO for a subscription plan matching PlanResource.
@JsonSerializable(fieldRename: FieldRename.snake)
class PlanModel {
  final String id;
  final String name;

  /// Optional description from the API.
  final String? description;

  final double price;

  /// Duration in days as defined by API.
  final int? durationDays;

  /// Legacy billing cycle field kept for backward compatibility.
  final String? billingCycle;

  /// Whether this plan grants access to all courses.
  final bool? hasAllCourses;

  /// Nested service resource.
  final PlanServiceModel? service;

  const PlanModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.durationDays,
    this.billingCycle,
    this.hasAllCourses,
    this.service,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) =>
      _$PlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlanModelToJson(this);

  /// Returns the image URL from the nested service if available.
  String? get serviceImageUrl => service?.imageUrl;
}
