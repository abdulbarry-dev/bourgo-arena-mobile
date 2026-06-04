import 'package:bourgo_arena_mobile/data/models/notification_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';

void main() {
  group('NotificationModel', () {
    test('toJson and fromJson should be consistent', () {
      const model = NotificationModel(
        id: 1,
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
  });
}
