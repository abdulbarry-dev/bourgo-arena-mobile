import 'package:bourgo_arena_mobile/data/models/reservation_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';

/// Mapper to convert [ReservationModel] to [Reservation] and vice-versa.
class ReservationMapper {
  /// Converts [ReservationModel] to [Reservation].
  static Reservation toEntity(ReservationModel model) {
    final resolvedActivityTitle =
        model.activityTitle ?? model.activity?.title ?? '';
    final resolvedActivityId = model.activityId ?? model.activity?.id ?? '';
    final resolvedTime =
        model.time ?? model.slot?.time ?? model.slot?.startTime ?? '';
    final resolvedDate = model.date ?? '';

    return Reservation(
      id: model.id,
      activityId: resolvedActivityId,
      activitySlotId: model.activitySlotId,
      activityTitle: resolvedActivityTitle,
      date: resolvedDate,
      time: resolvedTime,
      duration: model.duration,
      startsAt: model.startsAt,
      endsAt: model.endsAt,
      price: model.price ?? 0.0,
      status: model.status ?? 'pending',
      paymentStatus: model.paymentStatus ?? 'unpaid',
      qrCode: model.qrCode,
      memberId: model.memberId,
    );
  }

  /// Converts [Reservation] to [ReservationModel] for POST /reservations.
  static ReservationModel fromEntity(Reservation entity) {
    return ReservationModel(
      id: entity.id,
      activityId: entity.activityId,
      activitySlotId: entity.activitySlotId,
      activityTitle: entity.activityTitle,
      memberId: entity.memberId,
      date: entity.date,
      time: entity.time,
      duration: entity.duration,
      startsAt: entity.startsAt,
      endsAt: entity.endsAt,
      price: entity.price,
      status: entity.status,
      paymentStatus: entity.paymentStatus,
      qrCode: entity.qrCode,
    );
  }
}

/// Extension for convenient mapping of [ReservationModel] list.
extension ReservationModelListX on List<ReservationModel> {
  /// Converts a list of [ReservationModel] to a list of [Reservation].
  List<Reservation> toEntityList() => map(ReservationMapper.toEntity).toList();
}
