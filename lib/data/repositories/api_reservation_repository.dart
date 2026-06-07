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
          : ((response as Map<String, dynamic>)['data'] as List<dynamic>? ??
                []);
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
      final body = {
        'activity_id': reservation.activityId,
        'activity_slot_id': reservation.activitySlotId,
        'date': reservation.date,
      };
      final response = await _apiClient.post('/reservations', body);
      final data = response is Map<String, dynamic>
          ? response
          : (response as Map<String, dynamic>);
      return Result.success(
        ReservationMapper.toEntity(ReservationModel.fromJson(data)),
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

  @override
  Future<Result<Map<String, dynamic>, Failure>> initiatePayment(
    String reservationId,
    String gateway,
  ) {
    return executeApiCall(() async {
      final response = await _apiClient
          .post('/reservations/$reservationId/payment/initiate', {
            'gateway': gateway,
            'success_url': 'bourgo://payment/success',
            'failure_url': 'bourgo://payment/failure',
          });
      final responseMap = response as Map<String, dynamic>;
      final data =
          responseMap['payment'] as Map<String, dynamic>? ?? responseMap;
      return Result.success(data);
    });
  }

  @override
  Future<Result<String, Failure>> verifyPayment(
    String reservationId,
    String paymentId,
  ) {
    return executeApiCall(() async {
      final response = await _apiClient.get(
        '/reservations/$reservationId/payment/verify?payment_id=$paymentId',
      );
      final status =
          (response as Map<String, dynamic>)['status'] as String? ?? 'unknown';
      return Result.success(status);
    });
  }
}
