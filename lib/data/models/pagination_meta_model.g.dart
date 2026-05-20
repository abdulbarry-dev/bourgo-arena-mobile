// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationMetaModel _$PaginationMetaModelFromJson(Map<String, dynamic> json) =>
    PaginationMetaModel(
      currentPage: (json['current_page'] as num).toInt(),
      from: (json['from'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      path: json['path'] as String,
      perPage: (json['per_page'] as num).toInt(),
      to: (json['to'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationMetaModelToJson(
  PaginationMetaModel instance,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'from': instance.from,
  'last_page': instance.lastPage,
  'path': instance.path,
  'per_page': instance.perPage,
  'to': instance.to,
  'total': instance.total,
};

PaginationLinksModel _$PaginationLinksModelFromJson(
  Map<String, dynamic> json,
) => PaginationLinksModel(
  first: json['first'] as String,
  last: json['last'] as String,
  prev: json['prev'] as String?,
  next: json['next'] as String?,
);

Map<String, dynamic> _$PaginationLinksModelToJson(
  PaginationLinksModel instance,
) => <String, dynamic>{
  'first': instance.first,
  'last': instance.last,
  'prev': instance.prev,
  'next': instance.next,
};
