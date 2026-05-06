import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';

/// Mock implementation of [ReservationRepository].
class MockReservationRepository implements ReservationRepository {
  @override
  Future<List<Reservation>> getReservations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  @override
  Future<Reservation> makeReservation(Reservation reservation) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return reservation;
  }

  @override
  Future<void> cancelReservation(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
