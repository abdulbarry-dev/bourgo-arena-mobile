import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/mappers/reservation_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/reservation_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';

/// Laravel API implementation of [ReservationRepository].
class ApiReservationRepository implements ReservationRepository {
  final ApiClient _apiClient;

  ApiReservationRepository(this._apiClient);

  @override
  Future<List<Reservation>> getReservations() async {
    final response = await _apiClient.get('/reservations') as List<dynamic>;
    return response
        .map(
          (json) => ReservationMapper.toEntity(
            ReservationModel.fromJson(json as Map<String, dynamic>),
          ),
        )
        .toList();
  }

  @override
  Future<Reservation> makeReservation(Reservation reservation) async {
    final model = ReservationMapper.fromEntity(reservation);
    final response = await _apiClient.post('/reservations', model.toJson());
    return ReservationMapper.toEntity(ReservationModel.fromJson(response));
  }

  @override
  Future<void> cancelReservation(String id) async {
    await _apiClient.delete('/reservations/$id');
  }
}
