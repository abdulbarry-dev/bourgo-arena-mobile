import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';

class ReservationWithPayment {
  final Reservation reservation;
  final Map<String, dynamic>? payment;

  const ReservationWithPayment({required this.reservation, this.payment});

  String? get paymentUrl => payment?['payment_url'] as String?;
  String? get paymentReference => payment?['payment_reference'] as String?;
  int? get depositPaymentId => payment?['id'] as int?;
  bool get requiresDeposit => paymentUrl != null;
}
