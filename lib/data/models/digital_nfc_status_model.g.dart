// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_nfc_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DigitalNfcStatusModel _$DigitalNfcStatusModelFromJson(
  Map<String, dynamic> json,
) => DigitalNfcStatusModel(
  supported: json['supported'] as bool,
  configured: json['configured'] as bool,
  eligible: json['eligible'] as bool,
  isReady: json['is_ready'] as bool,
  setupStatus: json['setup_status'] as String,
  reasons:
      (json['reasons'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  fallbackMethods:
      (json['fallback_methods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$DigitalNfcStatusModelToJson(
  DigitalNfcStatusModel instance,
) => <String, dynamic>{
  'supported': instance.supported,
  'configured': instance.configured,
  'eligible': instance.eligible,
  'is_ready': instance.isReady,
  'setup_status': instance.setupStatus,
  'reasons': instance.reasons,
  'fallback_methods': instance.fallbackMethods,
};
