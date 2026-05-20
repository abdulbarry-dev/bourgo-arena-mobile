import 'package:bourgo_arena_mobile/data/mappers/notification_mapper.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart'
    as entity;
import 'package:test/test.dart';

import 'mapper_test_fixtures.dart';

void main() {
  group('NotificationMapper', () {
    test('maps a fully populated DTO to an entity', () {
      final dto = testNotificationModel();

      final mapped = NotificationMapper.toEntity(dto);

      expect(mapped.id, dto.id);
      expect(mapped.title, dto.title);
      expect(mapped.message, dto.message);
      expect(mapped.timestamp, DateTime.parse(dto.timestamp));
      expect(mapped.type, dto.type);
      expect(mapped.isRead, dto.isRead);
    });

    test('handles nullable-equivalent values through parsed timestamps', () {
      final dto = testNotificationModel(timestamp: '2026-01-01T00:00:00.000Z');

      final mapped = NotificationMapper.toEntity(dto);

      expect(mapped.timestamp, DateTime.utc(2026, 1, 1));
    });

    test('preserves notification type mapping exactly', () {
      final dto = testNotificationModel(type: 'promotion');

      final mapped = NotificationMapper.toEntity(dto);

      expect(mapped.type, 'promotion');
    });

    test('maps an entity back to the DTO', () {
      final notification = entity.Notification(
        id: 9,
        title: 'Reminder',
        message: 'Your session starts soon.',
        timestamp: DateTime.utc(2026, 5, 8, 12),
        type: 'system',
        isRead: true,
      );

      final dto = NotificationMapper.fromEntity(notification);

      expect(dto.id, notification.id);
      expect(dto.timestamp, notification.timestamp.toIso8601String());
    });

    test('toEntityList converts a list of DTOs', () {
      final dtos = [testNotificationModel(id: 1), testNotificationModel(id: 2)];

      final entities = dtos.toEntityList();

      expect(entities.length, 2);
      expect(entities[0].id, 1);
      expect(entities[1].id, 2);
    });
  });
}
