// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      id: json['id'] as String,
      title: json['title'] as String?,
      name: json['name'] as String?,
      category: json['category'] as String?,
      basePrice: (json['base_price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      imageUrl: json['image_url'] as String?,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      capacity: (json['capacity'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'name': instance.name,
      'category': instance.category,
      'base_price': instance.basePrice,
      'currency': instance.currency,
      'image_url': instance.imageUrl,
      'icon': instance.icon,
      'description': instance.description,
      'features': instance.features,
      'capacity': instance.capacity,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'images': instance.images,
    };
