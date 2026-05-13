import 'package:json_annotation/json_annotation.dart';

part 'search_result_model.g.dart';

/// DTO for search result data.
@JsonSerializable(fieldRename: FieldRename.snake)
class SearchResultModel {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final String icon;

  const SearchResultModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultModelToJson(this);
}
