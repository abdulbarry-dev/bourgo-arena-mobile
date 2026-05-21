// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_nfc_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhysicalNfcStatusModel _$PhysicalNfcStatusModelFromJson(
  Map<String, dynamic> json,
) => PhysicalNfcStatusModel(
  hasCard: json['has_card'] as bool,
  cardUid: json['card_uid'] as String?,
  cardStatus: json['card_status'] as String?,
  isReady: json['is_ready'] as bool,
  fallbackMethods:
      (json['fallback_methods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$PhysicalNfcStatusModelToJson(
  PhysicalNfcStatusModel instance,
) => <String, dynamic>{
  'has_card': instance.hasCard,
  'card_uid': instance.cardUid,
  'card_status': instance.cardStatus,
  'is_ready': instance.isReady,
  'fallback_methods': instance.fallbackMethods,
};
