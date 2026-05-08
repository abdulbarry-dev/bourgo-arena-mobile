import 'package:bourgo_arena_mobile/data/models/notification_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart'
    as entity;

/// Mapper to convert between [NotificationModel] and [entity.Notification].
class NotificationMapper {
  /// Converts [NotificationModel] to [entity.Notification].
  static entity.Notification toEntity(NotificationModel model) {
    return entity.Notification(
      id: model.id,
      title: model.title,
      message: model.message,
      timestamp: DateTime.parse(model.timestamp),
      type: model.type,
      isRead: model.isRead,
    );
  }

  /// Converts [entity.Notification] to [NotificationModel].
  static NotificationModel fromEntity(entity.Notification entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      timestamp: entity.timestamp.toIso8601String(),
      type: entity.type,
      isRead: entity.isRead,
    );
  }
}
