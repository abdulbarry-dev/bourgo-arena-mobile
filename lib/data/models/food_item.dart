import 'package:json_annotation/json_annotation.dart';

part 'food_item.g.dart';

/// Model representing a food or drink item in the Food Corner.
@JsonSerializable(fieldRename: FieldRename.snake)
class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final int calories;
  final bool isAvailable;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.calories,
    required this.isAvailable,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
  Map<String, dynamic> toJson() => _$FoodItemToJson(this);
}
