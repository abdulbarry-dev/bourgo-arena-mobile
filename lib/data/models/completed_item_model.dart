import 'package:json_annotation/json_annotation.dart';

part 'completed_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CompletedItemModel {
  final String type;
  final String typeLabel;
  final String id;
  final String? date;
  final String? name;
  final String? completedAt;

  const CompletedItemModel({
    required this.type,
    required this.typeLabel,
    required this.id,
    this.date,
    this.name,
    this.completedAt,
  });

  factory CompletedItemModel.fromJson(Map<String, dynamic> json) =>
      _$CompletedItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompletedItemModelToJson(this);
}
