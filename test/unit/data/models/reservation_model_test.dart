import 'package:bourgo_arena_mobile/data/models/reservation_model.dart';
import 'package:test/test.dart';

void main() {
  group('ReservationModel', () {
    test('toJson and fromJson should be consistent', () {
      const model = ReservationModel(
        id: 'res-1',
        activityId: 'act-1',
        activityTitle: 'Tennis',
        date: '2026-05-10',
        time: '14:00',
        duration: '60 min',
        price: 20.0,
        status: 'confirmed',
        paymentStatus: 'paid',
        qrCode: 'QR123',
      );

      final json = model.toJson();
      final fromJson = ReservationModel.fromJson(json);

      expect(fromJson.id, model.id);
      expect(fromJson.activityId, model.activityId);
      expect(fromJson.activityTitle, model.activityTitle);
      expect(fromJson.date, model.date);
      expect(fromJson.time, model.time);
      expect(fromJson.duration, model.duration);
      expect(fromJson.price, model.price);
      expect(fromJson.status, model.status);
      expect(fromJson.paymentStatus, model.paymentStatus);
      expect(fromJson.qrCode, model.qrCode);
    });
  });
}
