import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:flutter/foundation.dart';

/// Service for managing reservations and related business logic.
class ReservationService extends ChangeNotifier {
  final ReservationRepository _reservationRepository;
  List<Reservation> _reservations = [];
  bool _isLoading = false;

  ReservationService(this._reservationRepository);

  /// List of user reservations.
  List<Reservation> get reservations => _reservations;

  /// Whether reservations are currently being loaded.
  bool get isLoading => _isLoading;

  /// Fetches reservations from the repository.
  Future<void> fetchReservations() async {
    _isLoading = true;
    notifyListeners();
    try {
      _reservations = await _reservationRepository.getReservations();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new reservation.
  Future<void> createReservation(Reservation reservation) async {
    await _reservationRepository.makeReservation(reservation);
    await fetchReservations();
  }

  /// Cancels a reservation.
  Future<void> cancelReservation(String id) async {
    await _reservationRepository.cancelReservation(id);
    await fetchReservations();
  }
}
