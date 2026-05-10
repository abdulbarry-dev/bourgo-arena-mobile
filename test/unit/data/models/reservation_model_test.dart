import 'package:bourgo_arena_mobile/data/models/reservation_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';

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

      check(fromJson.id).equals(model.id);
      check(fromJson.activityId).equals(model.activityId);
      check(fromJson.activityTitle).equals(model.activityTitle);
      check(fromJson.date).equals(model.date);
      check(fromJson.time).equals(model.time);
      check(fromJson.duration).equals(model.duration);
      check(fromJson.price).equals(model.price);
      check(fromJson.status).equals(model.status);
      check(fromJson.paymentStatus).equals(model.paymentStatus);
      check(fromJson.qrCode).equals(model.qrCode);
    });

    test('fromJson should handle null optional fields', () {
      final json = {
        'id': 'res-2',
        'activity_id': 'act-2',
        'activity_title': 'Padel',
        'date': '2026-05-11',
        'time': '10:00',
        'duration': '90 min',
        'price': 30.0,
        'status': 'pending',
        'payment_status': 'pending',
        'qr_code': null,
      };

      final model = ReservationModel.fromJson(json);

      check(model.qrCode).isNull();
      check(model.id).equals('res-2');
    });
  });
}
