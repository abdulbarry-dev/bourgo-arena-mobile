import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/mock_http_client.dart';
import 'package:bourgo_arena_mobile/data/api/mock_server_setup.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_auth_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_activity_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/mock_auth_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/mock_activity_repository.dart';
import 'package:bourgo_arena_mobile/data/services/auth_service.dart';
import 'package:bourgo_arena_mobile/data/services/activity_service.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_reservation_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/mock_reservation_repository.dart';
import 'package:bourgo_arena_mobile/data/services/reservation_service.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:flutter_api_mock_server/flutter_api_mock_server.dart';
import 'package:http/http.dart' as http;

/// Class responsible for initializing and providing dependencies.
class DI {
  static late final AuthService authService;
  static late final ActivityService activityService;
  static late final ReservationService reservationService;

  /// Initializes the dependency graph.
  static void init({bool useMockData = true, bool useMockServer = false}) {
    late AuthRepository authRepository;
    late ActivityRepository activityRepository;
    late ReservationRepository reservationRepository;

    if (useMockData && !useMockServer) {
      // Pure Mock Repositories
      authRepository = MockAuthRepository();
      activityRepository = MockActivityRepository();
      reservationRepository = MockReservationRepository();
    } else {
      // API-based Repositories (Real or Mock Server Intercepted)
      final mockServer = MockServer();
      if (useMockServer) {
        MockServerSetup.configure(mockServer);
      }

      final httpClient = useMockServer
          ? MockHttpClient(mockServer)
          : http.Client();

      final apiClient = ApiClient(
        baseUrl: 'https://api.bourgoarena.tn', // Dummy real URL
        client: httpClient,
      );

      authRepository = ApiAuthRepository(apiClient);
      activityRepository = ApiActivityRepository(apiClient);
      reservationRepository = ApiReservationRepository(apiClient);
    }

    authService = AuthService(authRepository);
    activityService = ActivityService(activityRepository);
    reservationService = ReservationService(reservationRepository);
  }
}
