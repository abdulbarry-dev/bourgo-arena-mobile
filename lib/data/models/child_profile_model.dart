import 'package:json_annotation/json_annotation.dart';
import 'package:bourgo_arena_mobile/data/models/plan_model.dart';
import 'package:bourgo_arena_mobile/data/models/subscription_model.dart';

part 'child_profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ChildProfileModel {
  @JsonKey(fromJson: _idFromJson)
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String? gender;
  final String? avatarUrl;
  final String? status;
  final bool? isArchived;
  final bool? hasActiveSubscription;

  @JsonKey(fromJson: _activeSubFromJson)
  final SubscriptionModel? activeSubscription;

  final String? createdAt;

  static String _idFromJson(dynamic json) => json.toString();

  static SubscriptionModel? _activeSubFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final planId = (json['plan_id'] ?? json['plan']?['id'] ?? '').toString();
    final planName = (json['plan_name'] ?? json['plan']?['name'] ?? '') as String;
    final planPrice = (json['plan']?['price'] as num?)?.toDouble() ?? 0.0;

    return SubscriptionModel(
      id: json['id'].toString(),
      plan: PlanModel(
        id: planId,
        name: planName,
        price: planPrice,
        description: json['plan']?['description'] as String?,
        durationDays: json['plan']?['duration_days'] as int?,
        billingCycle: json['plan']?['billing_cycle'] as String?,
        hasAllCourses: json['plan']?['has_all_courses'] as bool?,
        service: json['plan']?['service'] != null
            ? PlanServiceModel.fromJson(
                json['plan']!['service'] as Map<String, dynamic>)
            : null,
      ),
      service: json['service'] != null
          ? PlanServiceModel.fromJson(json['service'] as Map<String, dynamic>)
          : null,
      status: json['status'] as String?,
      startsAt: json['starts_at'] as String?,
      endsAt: json['ends_at'] as String?,
      daysRemaining: json['days_remaining'] as int?,
      paymentMethod: json['payment_method'] as String?,
      amountPaid: (json['amount_paid'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool?,
      receiptUrl: json['receipt_url'] as String?,
    );
  }

  const ChildProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.gender,
    this.avatarUrl,
    this.status,
    this.isArchived,
    this.hasActiveSubscription,
    this.activeSubscription,
    this.createdAt,
  });

  String get name => '$firstName $lastName';

  factory ChildProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ChildProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChildProfileModelToJson(this);
}
