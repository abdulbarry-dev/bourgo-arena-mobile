import 'package:bourgo_arena_mobile/core/config/app_config.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_activity_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_auth_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_course_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_notification_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_reservation_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_user_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/persistent_settings_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/settings_repository.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/notification_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_time_slots_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/complete_registration_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/request_family_account_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/update_password_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/cancel_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/notification/get_notifications_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/is_language_selected_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

/// Initializes the dependency injection container.
Future<void> initLocator() async {
  // External
  final sharedPrefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

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
  locator.registerLazySingleton<CourseRepository>(
    () => ApiCourseRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<NotificationRepository>(
    () => ApiNotificationRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<SettingsRepository>(
    () => PersistentSettingsRepository(locator<SharedPreferences>()),
  );

  // Use Cases
  locator.registerLazySingleton(() => LoginUseCase(locator()));
  locator.registerLazySingleton(() => LogoutUseCase(locator()));
  locator.registerLazySingleton(() => RegisterUseCase(locator()));
  locator.registerLazySingleton(() => CompleteRegistrationUseCase(locator()));
  locator.registerLazySingleton(() => SendOtpUseCase(locator()));
  locator.registerLazySingleton(() => VerifyOtpUseCase(locator()));
  locator.registerLazySingleton(
    () => RequestFamilyAccountOtpUseCase(locator()),
  );
  locator.registerLazySingleton(() => UpdatePasswordUseCase(locator()));
  locator.registerLazySingleton(() => GetActivitiesUseCase(locator()));
  locator.registerLazySingleton(() => GetTimeSlotsUseCase(locator()));
  locator.registerLazySingleton(() => GetUserBookingsUseCase(locator()));
  locator.registerLazySingleton(() => CancelBookingUseCase(locator()));
  locator.registerLazySingleton(() => GetCoursesUseCase(locator()));
  locator.registerLazySingleton(() => GetNotificationsUseCase(locator()));
  locator.registerLazySingleton(() => GetUserProfileUseCase(locator()));
  locator.registerLazySingleton(() => UpdateUserProfileUseCase(locator()));

  // Settings Use Cases
  locator.registerLazySingleton(() => GetThemeModeUseCase(locator()));
  locator.registerLazySingleton(() => SetThemeModeUseCase(locator()));
  locator.registerLazySingleton(() => GetLocaleUseCase(locator()));
  locator.registerLazySingleton(() => SetLocaleUseCase(locator()));
  locator.registerLazySingleton(() => IsLanguageSelectedUseCase(locator()));
  locator
      .registerLazySingleton(() => GetNotificationsEnabledUseCase(locator()));
  locator
      .registerLazySingleton(() => SetNotificationsEnabledUseCase(locator()));

  // State Notifiers
  locator.registerLazySingleton(() => AuthStateNotifier(locator()));

  // ViewModels
  locator.registerLazySingleton(
    () => SettingsViewModel(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
}
