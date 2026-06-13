import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/reservation_mapper.dart';
import 'package:bourgo_arena_mobile/data/mappers/time_slot_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/reservation_model.dart';
import 'package:bourgo_arena_mobile/data/models/time_slot_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation_with_payment.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
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
      final ongoingFuture = _apiClient.get(
        '/reservations/ongoing',
        fullResponse: true,
        queryParameters: {'page': '1', 'per_page': '50'},
      );
      final historyFuture = _apiClient.get(
        '/reservations/history',
        fullResponse: true,
        queryParameters: {'page': '1', 'per_page': '50'},
      );

      final results = await Future.wait([ongoingFuture, historyFuture]);
      final ongoingResp = results[0] as Map<String, dynamic>;
      final historyResp = results[1] as Map<String, dynamic>;

      final allData = <dynamic>[];
      for (final resp in [ongoingResp, historyResp]) {
        final data = resp['data'] as List<dynamic>?;
        if (data != null) {
          allData.addAll(data);
        }
      }

      final entities = allData
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
  Future<Result<List<Reservation>, Failure>> getOngoingReservations({
    int page = 1,
    int perPage = 20,
  }) {
    if (!_apiClient.hasToken) {
      return Future.value(const Success([]));
    }
    return executeApiCall(() async {
      final response =
          await _apiClient.get(
                '/reservations/ongoing',
                fullResponse: true,
                queryParameters: {
                  'page': page.toString(),
                  'per_page': perPage.toString(),
                },
              )
              as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
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
  Future<Result<List<Reservation>, Failure>> getReservationHistory({
    int page = 1,
    int perPage = 20,
  }) {
    if (!_apiClient.hasToken) {
      return Future.value(const Success([]));
    }
    return executeApiCall(() async {
      final response =
          await _apiClient.get(
                '/reservations/history',
                fullResponse: true,
                queryParameters: {
                  'page': page.toString(),
                  'per_page': perPage.toString(),
                },
              )
              as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
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
  Future<Result<ReservationWithPayment, Failure>> makeReservation(
    Reservation reservation, {
    String? paymentMethod,
  }) {
    return executeApiCall(() async {
      final body = <String, dynamic>{
        'activity_id': reservation.activityId,
        'activity_slot_id': reservation.activitySlotId,
        'date': reservation.date,
        'amount': reservation.price,
      };
      if (reservation.memberId != null) {
        body['member_id'] = reservation.memberId;
      }
      if (paymentMethod != null) {
        body['payment_method'] = paymentMethod;
      }
      // fullResponse: true keeps the entire envelope so the top-level
      // 'payment' key (sibling of 'data') is not stripped away.
      final response =
          await _apiClient.post('/reservations', body, fullResponse: true)
              as Map<String, dynamic>;
      final data = response['data'] as Map<String, dynamic>? ?? response;
      final payment = response['payment'] as Map<String, dynamic>?;
      return Result.success(
        ReservationWithPayment(
          reservation: ReservationMapper.toEntity(
            ReservationModel.fromJson(data),
          ),
          payment: payment,
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

  @override
  Future<Result<Map<String, dynamic>, Failure>> initiatePayment(
    String reservationId, {
    double? amount,
  }) {
    return executeApiCall(() async {
      final body = <String, dynamic>{};
      if (amount != null) body['amount'] = amount;
      final response = await _apiClient.post(
        '/reservations/$reservationId/payment/initiate',
        body,
      );
      final responseMap = response as Map<String, dynamic>;
      final data = responseMap['data'] as Map<String, dynamic>? ?? responseMap;
      final payment = data['payment'] as Map<String, dynamic>? ?? data;
      return Result.success(payment);
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

  @override
  Future<Result<List<TimeSlot>, Failure>> getReservationSlots(String date) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get(
                '/reservations/slots',
                queryParameters: {'date': date},
              )
              as List<dynamic>;
      final slots = response
          .map(
            (json) => TimeSlotMapper.toEntity(
              TimeSlotModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(slots);
    });
  }
}
