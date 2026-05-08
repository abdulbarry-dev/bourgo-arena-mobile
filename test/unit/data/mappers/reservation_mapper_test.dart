import 'package:bourgo_arena_mobile/data/mappers/reservation_mapper.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:test/test.dart';

import 'mapper_test_fixtures.dart';

void main() {
  group('ReservationMapper', () {
    test('maps a fully populated DTO to an entity', () {
      final dto = testReservationModel();

      final mapped = ReservationMapper.toEntity(dto);

      expect(mapped.id, dto.id);
      expect(mapped.activityId, dto.activityId);
      expect(mapped.activityTitle, dto.activityTitle);
      expect(mapped.date, dto.date);
      expect(mapped.time, dto.time);
      expect(mapped.duration, dto.duration);
      expect(mapped.price, dto.price);
      expect(mapped.status, dto.status);
      expect(mapped.paymentStatus, dto.paymentStatus);
      expect(mapped.qrCode, dto.qrCode);
    });

    test('handles boundary values such as zero price and empty qr code', () {
      final dto = testReservationModel(price: 0.0, qrCode: '');

      final mapped = ReservationMapper.toEntity(dto);

      expect(mapped.price, 0.0);
      expect(mapped.qrCode, '');
    });

    test('preserves renamed backend fields exactly', () {
      final dto = testReservationModel(activityTitle: 'Basketball');

      final mapped = ReservationMapper.toEntity(dto);

      expect(mapped.activityTitle, 'Basketball');
    });

    test('maps an entity back to the DTO', () {
      final reservation = Reservation(
        id: 'reservation-9',
        activityId: 'activity-9',
        activityTitle: 'Basketball',
        date: '2026-05-09',
        time: '19:30',
        duration: '60 min',
        price: 30.0,
        status: 'pending',
        paymentStatus: 'unpaid',
        qrCode: 'QR-999',
      );

      final dto = ReservationMapper.fromEntity(reservation);

      expect(dto.id, reservation.id);
      expect(dto.qrCode, reservation.qrCode);
    });
  });
}
