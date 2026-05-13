import 'package:json_annotation/json_annotation.dart';

part 'subscription_model.g.dart';

/// DTO for subscription plan data.
@JsonSerializable(fieldRename: FieldRename.snake)
class SubscriptionModel {
  final String id;
  final String name;
  final double price;
  final List<String> benefits;
  final int durationMonths;

  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.price,
    required this.benefits,
    required this.durationMonths,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);
}
