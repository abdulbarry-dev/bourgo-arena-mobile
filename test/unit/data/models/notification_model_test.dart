import 'package:bourgo_arena_mobile/data/models/notification_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';

void main() {
  group('NotificationModel', () {
    test('toJson and fromJson should be consistent', () {
      const model = NotificationModel(
        id: 'notif-1',
        title: 'Welcome',
        message: 'Hello world',
        timestamp: '2026-05-09T10:00:00Z',
        type: 'info',
        isRead: false,
      );

      final json = model.toJson();
      final fromJson = NotificationModel.fromJson(json);

      check(fromJson.id).equals(model.id);
      check(fromJson.title).equals(model.title);
      check(fromJson.message).equals(model.message);
      check(fromJson.timestamp).equals(model.timestamp);
      check(fromJson.type).equals(model.type);
      check(fromJson.isRead).equals(model.isRead);
    });

    test('fromJson should handle null optional fields', () {
      final json = {
        'id': 'notif-2',
        'title': 'No Type',
        'message': 'Message without type',
        'timestamp': '2026-05-09T11:00:00Z',
        'type': null,
        'is_read': true,
      };

      final model = NotificationModel.fromJson(json);

      check(model.type).isNull();
      check(model.id).equals('notif-2');
      check(model.isRead).isTrue();
    });
  });
}
