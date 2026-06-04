import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/reservation_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/reservation_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';

/// Laravel API implementation of [ReservationRepository].
class ApiReservationRepository implements ReservationRepository {
  final ApiClient _apiClient;

  ApiReservationRepository(this._apiClient);

  @override
  Future<Result<List<Reservation>, Failure>> getReservations() {
    if (!_apiClient.hasToken) {
      return Future.value(const Success([]));
    }
    return executeApiCall(() async {
      final response = await _apiClient.get('/reservations');
      final List<dynamic> data = response is List
          ? response
          : ((response as Map<String, dynamic>)['data'] as List<dynamic>? ?? []);
      final entities = data
          .map(
            (json) => ReservationMapper.toEntity(
              ReservationModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    });
  }

  @override
  Future<Result<Reservation, Failure>> makeReservation(
    Reservation reservation,
  ) {
    return executeApiCall(() async {
      final model = ReservationMapper.fromEntity(reservation);
      final response = await _apiClient.post('/reservations', model.toJson());
      return Result.success(
        ReservationMapper.toEntity(
          ReservationModel.fromJson(response as Map<String, dynamic>),
        ),
      );
    });
  }

  @override
  Future<Result<void, Failure>> cancelReservation(String id) {
    return executeApiCall(() async {
      await _apiClient.delete('/reservations/$id');
      return Result.success(null);
    });
  }
}
