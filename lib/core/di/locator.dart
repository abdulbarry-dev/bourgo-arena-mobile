import 'package:bourgo_arena_mobile/core/config/app_config.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_activity_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_auth_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_reservation_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_user_repository.dart';
import 'package:bourgo_arena_mobile/data/services/activity_service.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/data/services/reservation_service.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/complete_registration_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/request_family_account_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/cancel_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

/// Initializes the dependency injection container.
Future<void> initLocator() async {
  // Networking
  final httpClient = http.Client();
  final apiClient = ApiClient(baseUrl: AppConfig.baseUrl, client: httpClient);
  locator.registerLazySingleton<ApiClient>(() => apiClient);

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => ApiAuthRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<ActivityRepository>(
    () => ApiActivityRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<ReservationRepository>(
    () => ApiReservationRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<UserRepository>(
    () => ApiUserRepository(locator<ApiClient>()),
  );

  // Use Cases
  locator.registerLazySingleton(() => LoginUseCase(locator()));
  locator.registerLazySingleton(() => LogoutUseCase(locator()));
  locator.registerLazySingleton(() => RegisterUseCase(locator()));
  locator.registerLazySingleton(() => CompleteRegistrationUseCase(locator()));
  locator.registerLazySingleton(() => SendOtpUseCase(locator()));
  locator.registerLazySingleton(() => VerifyOtpUseCase(locator()));
  locator.registerLazySingleton(() => RequestFamilyAccountOtpUseCase(locator()));
  locator.registerLazySingleton(() => GetActivitiesUseCase(locator()));
  locator.registerLazySingleton(() => GetUserBookingsUseCase(locator()));
  locator.registerLazySingleton(() => CancelBookingUseCase(locator()));

  // State Notifiers
  locator.registerLazySingleton(() => AuthStateNotifier(locator()));

  // Services
  locator.registerLazySingleton(() => ActivityService(locator()));
  locator.registerLazySingleton(() => ReservationService(locator()));
  locator.registerLazySingleton(
    () => DataService(
      userRepository: locator(),
      activityRepository: locator(),
      reservationRepository: locator(),
    ),
  );
}
