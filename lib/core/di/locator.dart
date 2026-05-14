import 'package:bourgo_arena_mobile/core/config/app_config.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_activity_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_auth_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_course_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_device_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_notification_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_reservation_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_subscription_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_user_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/local_session_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/device_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/subscription_repository.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/notification_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_search_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/search_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/search/search_use_case.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_family_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/add_child_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_children_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/remove_child_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_time_slots_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/forgot_password_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/complete_registration_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/reset_password_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/request_family_account_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/update_password_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/cancel_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/make_reservation_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/device/register_device_token_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/notification/get_notifications_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/complete_language_selection_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/is_language_selected_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscription_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:bourgo_arena_mobile/core/utils/device_token_registrar.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

/// Initializes the dependency injection container.
Future<void> initLocator() async {
  // External
  final sharedPrefs = await SharedPreferences.getInstance();

  // Local Session Repository — the single source for all SharedPreferences access.
  locator.registerLazySingleton<SessionRepository>(
    () => LocalSessionRepository(sharedPrefs),
  );

  // Networking
  final httpClient = http.Client();
  final apiClient = ApiClient(baseUrl: AppConfig.baseUrl, client: httpClient);

  // Initialize the token from storage if it exists
  final tokenResult = await locator<SessionRepository>().getAuthToken();
  tokenResult.when(
    success: (token) {
      if (token != null) {
        apiClient.setToken(token);
      }
    },
    failure: (_) {},
  );

  locator.registerLazySingleton<ApiClient>(() => apiClient);

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => ApiAuthRepository(locator<ApiClient>(), locator<SessionRepository>()),
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
  locator.registerLazySingleton<SearchRepository>(
    () => ApiSearchRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<NotificationRepository>(
    () => ApiNotificationRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<FamilyRepository>(
    () => ApiFamilyRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<SubscriptionRepository>(
    () => ApiSubscriptionRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<DeviceRepository>(
    () => ApiDeviceRepository(locator<ApiClient>()),
  );
  // SettingsRepository adapter removed — consumers should use SessionRepository directly.

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
  locator.registerLazySingleton(() => ForgotPasswordUseCase(locator()));
  locator.registerLazySingleton(() => ResetPasswordUseCase(locator()));
  locator.registerLazySingleton(() => GetActivitiesUseCase(locator()));
  locator.registerLazySingleton(() => GetTimeSlotsUseCase(locator()));
  locator.registerLazySingleton(() => GetUserBookingsUseCase(locator()));
  locator.registerLazySingleton(() => MakeReservationUseCase(locator()));
  locator.registerLazySingleton(() => CancelBookingUseCase(locator()));
  locator.registerLazySingleton(() => GetCoursesUseCase(locator()));
  locator.registerLazySingleton(() => GetNotificationsUseCase(locator()));
  locator.registerLazySingleton(() => SearchUseCase(locator()));
  locator.registerLazySingleton(() => GetUserProfileUseCase(locator()));
  locator.registerLazySingleton(() => UpdateUserProfileUseCase(locator()));
  locator.registerLazySingleton(() => GetChildrenUseCase(locator()));
  locator.registerLazySingleton(() => AddChildUseCase(locator()));
  locator.registerLazySingleton(() => RemoveChildUseCase(locator()));
  locator.registerLazySingleton(() => GetActiveSubscriptionUseCase(locator()));
  locator.registerLazySingleton(() => RegisterDeviceTokenUseCase(locator()));
  locator.registerLazySingleton(
    () => DeviceTokenRegistrar(
      locator<SessionRepository>(),
      locator<RegisterDeviceTokenUseCase>(),
    ),
  );

  // Settings Use Cases
  locator.registerLazySingleton(() => GetThemeModeUseCase(locator()));
  locator.registerLazySingleton(() => SetThemeModeUseCase(locator()));
  locator.registerLazySingleton(() => GetLocaleUseCase(locator()));
  locator.registerLazySingleton(() => SetLocaleUseCase(locator()));
  locator.registerLazySingleton(() => IsLanguageSelectedUseCase(locator()));
  locator.registerLazySingleton(
    () => CompleteLanguageSelectionUseCase(locator()),
  );
  locator.registerLazySingleton(
    () => GetNotificationsEnabledUseCase(locator()),
  );
  locator.registerLazySingleton(
    () => SetNotificationsEnabledUseCase(locator()),
  );

  // State Notifiers
  locator.registerSingletonAsync<AuthStateNotifier>(() async {
    final notifier = AuthStateNotifier(locator(), locator(), locator());
    await notifier.initialize();
    return notifier;
  });

  // ViewModels — registered as async so initialize() is awaited at startup.
  locator.registerSingletonAsync<SettingsViewModel>(() async {
    final vm = SettingsViewModel(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    );
    await vm.initialize();
    return vm;
  });

  // Wait for all async singletons before the app starts.
  await locator.allReady();
}
