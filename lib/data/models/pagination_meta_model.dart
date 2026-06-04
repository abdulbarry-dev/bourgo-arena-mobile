import 'package:json_annotation/json_annotation.dart';

part 'pagination_meta_model.g.dart';

/// DTO for Laravel API pagination metadata.
@JsonSerializable(fieldRename: FieldRename.snake)
class PaginationMetaModel {
  final int currentPage;
  final int from;
  final int lastPage;
  final String path;
  final int perPage;
  final int to;
  final int total;

  const PaginationMetaModel({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationMetaModelToJson(this);
}

/// DTO for Laravel API pagination links.
@JsonSerializable()
class PaginationLinksModel {
  final String first;
  final String last;
  final String? prev;
  final String? next;

  const PaginationLinksModel({
    required this.first,
    required this.last,
    this.prev,
    this.next,
  });

  factory PaginationLinksModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinksModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationLinksModelToJson(this);
}
