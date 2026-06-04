import 'package:json_annotation/json_annotation.dart';

part 'plan_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PlanModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String billingCycle;

  @JsonKey(name: 'service')
  final Map<String, dynamic>? service;

  const PlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.billingCycle,
    this.service,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) =>
      _$PlanModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlanModelToJson(this);

  String? get serviceImageUrl => service?['image_url'] as String?;
}
