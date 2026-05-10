import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

/// Model representing a user notification.
@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationModel {
  /// Unique identifier.
  final String id;

  /// Title of the notification.
  final String title;

  /// Body message.
  final String message;

  /// Timestamp string (ISO format).
  final String timestamp;

  /// Type of notification (booking, promotion, system).
  final String? type;

  /// Whether the notification has been read.
  final bool isRead;

  /// Creates a new [NotificationModel] instance.
  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.type,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
