import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/domain/repositories/service_repository.dart';

class GetServiceDetailsUseCase {
  final ServiceRepository repository;

  GetServiceDetailsUseCase(this.repository);

  Future<Result<Service, Failure>> call(int serviceId) {
    return repository.getServiceDetails(serviceId);
  }
}
