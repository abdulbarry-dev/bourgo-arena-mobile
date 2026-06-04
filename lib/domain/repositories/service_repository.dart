import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';

abstract class ServiceRepository {
  /// Fetches a paginated list of services.
  Future<Result<List<Service>, Failure>> getServices({
    int page = 1,
    int limit = 15,
  });

  /// Fetches details for a specific service.
  Future<Result<Service, Failure>> getServiceDetails(int serviceId);
}
