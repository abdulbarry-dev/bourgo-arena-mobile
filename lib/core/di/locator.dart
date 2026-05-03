import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/mock_http_client.dart';
import 'package:bourgo_arena_mobile/data/api/mock_server_setup.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_activity_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_auth_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_reservation_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/mock_activity_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/mock_auth_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/mock_reservation_repository.dart';
import 'package:bourgo_arena_mobile/data/services/activity_service.dart';
import 'package:bourgo_arena_mobile/data/services/auth_service.dart';
import 'package:bourgo_arena_mobile/data/services/reservation_service.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/cancel_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:flutter_api_mock_server/flutter_api_mock_server.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:bourgo_arena_mobile/core/config/app_config.dart';

final locator = GetIt.instance;

/// Initializes the dependency injection container.
Future<void> initLocator({
  bool useMockData = AppConfig.useMockData,
  bool useMockServer = AppConfig.useMockServer,
}) async {
  // Repositories
  if (useMockData && !useMockServer) {
    locator.registerLazySingleton<AuthRepository>(() => MockAuthRepository());
    locator.registerLazySingleton<ActivityRepository>(() => MockActivityRepository());
    locator.registerLazySingleton<ReservationRepository>(() => MockReservationRepository());
  } else {
    final mockServer = MockServer();
    if (useMockServer) {
      MockServerSetup.configure(mockServer);
    }

    final httpClient = useMockServer ? MockHttpClient(mockServer) : http.Client();
    final apiClient = ApiClient(
      baseUrl: AppConfig.baseUrl,
      client: httpClient,
    );

    locator.registerLazySingleton<AuthRepository>(() => ApiAuthRepository(apiClient));
    locator.registerLazySingleton<ActivityRepository>(() => ApiActivityRepository(apiClient));
    locator.registerLazySingleton<ReservationRepository>(() => ApiReservationRepository(apiClient));
  }

  // Use Cases
  locator.registerLazySingleton(() => LoginUseCase(locator()));
  locator.registerLazySingleton(() => LogoutUseCase(locator()));
  locator.registerLazySingleton(() => GetActivitiesUseCase(locator()));
  locator.registerLazySingleton(() => GetUserBookingsUseCase(locator()));
  locator.registerLazySingleton(() => CancelBookingUseCase(locator()));

  // Services
  locator.registerLazySingleton(() => AuthService(locator()));
  locator.registerLazySingleton(() => ActivityService(locator()));
  locator.registerLazySingleton(() => ReservationService(locator()));
}
