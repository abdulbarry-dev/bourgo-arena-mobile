import 'package:bourgo_arena_mobile/data/models/reservation_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';

/// Mapper to convert [ReservationModel] to [Reservation] and vice-versa.
class ReservationMapper {
  /// Converts [ReservationModel] to [Reservation].
  static Reservation toEntity(ReservationModel model) {
    return Reservation(
      id: model.id,
      activityId: model.activityId,
      activityTitle: model.activityTitle,
      date: model.date,
      time: model.time,
      duration: model.duration,
      price: model.price,
      status: model.status,
      paymentStatus: model.paymentStatus,
      qrCode: model.qrCode ?? '',
      memberId: model.memberId,
    );
  }

  /// Converts [Reservation] to [ReservationModel].
  static ReservationModel fromEntity(Reservation entity) {
    return ReservationModel(
      id: entity.id,
      activityId: entity.activityId,
      activityTitle: entity.activityTitle,
      memberId: entity.memberId,
      date: entity.date,
      time: entity.time,
      duration: entity.duration,
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
