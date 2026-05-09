import 'package:bourgo_arena_mobile/data/models/notification_model.dart';
import 'package:test/test.dart';

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

      expect(fromJson.id, model.id);
      expect(fromJson.title, model.title);
      expect(fromJson.message, model.message);
      expect(fromJson.timestamp, model.timestamp);
      expect(fromJson.type, model.type);
      expect(fromJson.isRead, model.isRead);
    });
  });
}
