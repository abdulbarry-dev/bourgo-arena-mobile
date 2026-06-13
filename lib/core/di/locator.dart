import 'package:bourgo_arena_mobile/presentation/profile/viewmodels/transaction_history_view_model.dart';
import 'package:bourgo_arena_mobile/domain/usecases/payment/get_full_payment_history_use_case.dart';
import "package:bourgo_arena_mobile/domain/usecases/settings/complete_theme_selection_use_case.dart";
import "package:bourgo_arena_mobile/domain/usecases/settings/is_theme_selected_use_case.dart";
import "package:bourgo_arena_mobile/domain/usecases/course/enroll_in_course_use_case.dart";
import 'package:bourgo_arena_mobile/core/config/app_config.dart';
import 'package:bourgo_arena_mobile/core/services/device_identity_service.dart';
import 'package:bourgo_arena_mobile/core/utils/device_identity_provider.dart';
import 'package:bourgo_arena_mobile/core/utils/device_identity_storage.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_activity_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_auth_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_course_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_device_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_device_registration_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_notification_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_reservation_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_pricing_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_subscription_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_user_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/local_session_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/device_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/device_registration_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/subscription_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_event_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/event_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_loyalty_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/loyalty_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_payment_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/payment_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_plan_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/plan_repository.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/notification_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/pricing_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_search_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/search_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/search/search_use_case.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_family_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_service_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/service_repository.dart';
// NFC-related imports removed — NFC functionality has been excised.
import 'package:bourgo_arena_mobile/domain/usecases/family/add_child_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/update_child_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_children_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/remove_child_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/disable_family_feature_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/enable_family_feature_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/buy_child_subscription_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_available_sessions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/book_child_session_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_reservations_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_schedule_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/complete_child_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_completed_items_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_time_slots_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/delete_account_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/auth_use_cases.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/cancel_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_ongoing_reservations_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_reservation_history_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/make_reservation_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_reservation_slots_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_course_sessions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_session_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/project_points_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_loyalty_balance_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_loyalty_payments_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/pay_with_loyalty_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/get_my_events_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/pricing/get_contextual_price_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/device/register_device_token_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/notification/get_notifications_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/notification/mark_notifications_read_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/complete_language_selection_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/is_language_selected_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_plans_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_subscription_history_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/cancel_subscription_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/subscribe_to_plan_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_service_details_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_services_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/profile/family_management_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:bourgo_arena_mobile/core/utils/device_token_registrar.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';

final locator = GetIt.instance;

/// Initializes the dependency injection container.
Future<void> initLocator() async {
  // External
  final sharedPrefs = await SharedPreferences.getInstance();

  // Local Session Repository — the single source for all SharedPreferences access.
  locator.registerLazySingleton<SessionRepository>(
    () => LocalSessionRepository(sharedPrefs),
  );

  // Device Identity — persisted separately from session (survives logout)
  final deviceIdentityStorage = DeviceIdentityStorage(sharedPrefs);
  locator.registerLazySingleton<DeviceIdentityStorage>(
    () => deviceIdentityStorage,
  );
  locator.registerLazySingleton<DeviceIdentityProvider>(
    () => DeviceIdentityProvider(),
  );

  // Cache store
  final cacheDir = await getApplicationDocumentsDirectory();
  final cacheStore = HiveCacheStore(
    cacheDir.path,
    hiveBoxName: 'bourgo_api_cache',
  );

  final cacheOptions = CacheOptions(
    store: cacheStore,
    policy: CachePolicy.request,
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(days: 7),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );

  // Networking
  final apiClient = ApiClient(
    baseUrl: AppConfig.baseUrl,
    sharedPreferences: sharedPrefs,
    deviceIdentityStorage: deviceIdentityStorage,
    cacheOptions: cacheOptions,
  );

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

  locator.registerLazySingleton<ApiClient>(() {
    // Lazy setup of onAuthError so it can resolve AuthStateNotifier later
    apiClient.onAuthError = (state) {
      if (locator.isRegistered<LogoutUseCase>()) {
        locator<LogoutUseCase>().call();
      }
    };
    return apiClient;
  });

  // Device Registration Repository
  locator.registerLazySingleton<DeviceRegistrationRepository>(
    () => ApiDeviceRegistrationRepository(locator<ApiClient>()),
  );

  // Initialize device identity (register/refresh device token) before any API calls
  final deviceIdentityService = DeviceIdentityService(
    locator<DeviceIdentityProvider>(),
    deviceIdentityStorage,
    locator<DeviceRegistrationRepository>(),
    apiClient,
  );
  await deviceIdentityService.initialize();
  locator.registerLazySingleton<DeviceIdentityService>(
    () => deviceIdentityService,
  );

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => ApiAuthRepository(
      locator<ApiClient>(),
      locator<SessionRepository>(),
      locator<DeviceIdentityStorage>(),
      locator<DeviceRegistrationRepository>(),
    ),
  );
  locator.registerLazySingleton<ActivityRepository>(
    () => ApiActivityRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<ReservationRepository>(
    () => ApiReservationRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<PricingRepository>(
    () => ApiPricingRepository(locator<ApiClient>()),
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
  // NFC repository and device provider registrations removed.
  // SettingsRepository adapter removed — consumers should use SessionRepository directly.
  locator.registerLazySingleton<ServiceRepository>(
    () => ApiServiceRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<EventRepository>(
    () => ApiEventRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<LoyaltyRepository>(
    () => ApiLoyaltyRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<PaymentRepository>(
    () => ApiPaymentRepository(locator<ApiClient>()),
  );
  locator.registerLazySingleton<PlanRepository>(
    () => ApiPlanRepository(locator<ApiClient>()),
  );

  // Use Cases
  locator.registerLazySingleton(() => LoginUseCase(locator()));
  locator.registerLazySingleton(() => LogoutUseCase(locator()));
  locator.registerLazySingleton(() => RegisterUseCase(locator()));
  locator.registerLazySingleton(() => CompleteRegistrationUseCase(locator()));
  locator.registerLazySingleton(() => SendOtpUseCase(locator()));
  locator.registerLazySingleton(() => GetServicesUseCase(locator()));
  locator.registerLazySingleton(() => GetServiceDetailsUseCase(locator()));
  locator.registerLazySingleton(() => VerifyOtpUseCase(locator()));
  locator.registerLazySingleton(() => VerifyEmailUseCase(locator()));
  locator.registerLazySingleton(() => VerifyPhoneUseCase(locator()));
  locator.registerLazySingleton(() => GetVerificationStatusUseCase(locator()));
  locator.registerLazySingleton(
    () => RequestFamilyAccountOtpUseCase(locator()),
  );
  locator.registerLazySingleton(() => DeleteAccountUseCase(locator()));
  locator.registerLazySingleton(() => UpdatePasswordUseCase(locator()));
  locator.registerLazySingleton(() => ForgotPasswordUseCase(locator()));
  locator.registerLazySingleton(() => ResetPasswordUseCase(locator()));
  locator.registerLazySingleton(() => GetActivitiesUseCase(locator()));
  locator.registerLazySingleton(() => GetTimeSlotsUseCase(locator()));
  locator.registerLazySingleton(() => GetUserBookingsUseCase(locator()));
  locator.registerLazySingleton(() => GetOngoingReservationsUseCase(locator()));
  locator.registerLazySingleton(() => GetReservationHistoryUseCase(locator()));
  locator.registerLazySingleton(() => MakeReservationUseCase(locator()));
  locator.registerLazySingleton(() => CancelBookingUseCase(locator()));
  locator.registerLazySingleton(() => GetCoursesUseCase(locator()));
  locator.registerLazySingleton(() => BookCourseSessionUseCase(locator()));
  locator.registerLazySingleton(() => GetCourseSessionsUseCase(locator()));
  locator.registerLazySingleton(() => GetSessionBookingUseCase(locator()));
  locator.registerLazySingleton(() => GetReservationSlotsUseCase(locator()));
  locator.registerLazySingleton(() => GetNotificationsUseCase(locator()));
  locator.registerLazySingleton(() => MarkNotificationsReadUseCase(locator()));
  locator.registerLazySingleton(() => SearchUseCase(locator()));
  locator.registerLazySingleton(() => GetUserProfileUseCase(locator()));
  locator.registerLazySingleton(() => UpdateUserProfileUseCase(locator()));
  locator.registerLazySingleton(() => GetChildrenUseCase(locator()));
  locator.registerLazySingleton(
    () => GetFamilyMembersUseCase(locator<FamilyRepository>()),
  );
  locator.registerLazySingleton(() => AddChildUseCase(locator()));
  locator.registerLazySingleton(() => UpdateChildUseCase(locator()));
  locator.registerLazySingleton(() => RemoveChildUseCase(locator()));
  locator.registerLazySingleton(() => DisableFamilyFeatureUseCase(locator()));
  locator.registerLazySingleton(() => EnableFamilyFeatureUseCase(locator()));
  locator.registerLazySingleton(() => GetChildProfileUseCase(locator()));
  locator.registerLazySingleton(() => BuyChildSubscriptionUseCase(locator()));
  locator.registerLazySingleton(() => GetChildSubscriptionsUseCase(locator()));
  locator.registerLazySingleton(() => GetChildBookingsUseCase(locator()));
  locator.registerLazySingleton(
    () => GetChildAvailableSessionsUseCase(locator()),
  );
  locator.registerLazySingleton(() => BookChildSessionUseCase(locator()));
  locator.registerLazySingleton(() => GetChildReservationsUseCase(locator()));
  locator.registerLazySingleton(() => GetChildScheduleUseCase(locator()));
  locator.registerLazySingleton(() => CompleteChildBookingUseCase(locator()));
  locator.registerLazySingleton(() => GetChildCompletedItemsUseCase(locator()));
  locator.registerLazySingleton(() => GetActiveSubscriptionsUseCase(locator()));
  locator.registerLazySingleton(() => GetPlansUseCase(locator()));
  locator.registerLazySingleton(() => GetFullPaymentHistoryUseCase(locator()));
  locator.registerLazySingleton(() => GetSubscriptionHistoryUseCase(locator()));
  locator.registerLazySingleton(() => CancelSubscriptionUseCase(locator()));
  locator.registerLazySingleton(() => RegisterDeviceTokenUseCase(locator()));
  locator.registerLazySingleton(() => const GetMemberTierUseCase());
  locator.registerLazySingleton(() => const ProjectPointsUseCase());
  locator.registerLazySingleton(() => GetLoyaltyBalanceUseCase(locator()));
  locator.registerLazySingleton(() => GetLoyaltyPaymentsUseCase(locator()));
  locator.registerLazySingleton(() => SubscribeToPlanUseCase(locator()));
  locator.registerLazySingleton(() => PayWithLoyaltyUseCase(locator()));
  locator.registerLazySingleton(() => GetEventsUseCase(locator()));
  locator.registerLazySingleton(() => GetEventByIdUseCase(locator()));
  locator.registerLazySingleton(() => GetEventBracketUseCase(locator()));
  locator.registerLazySingleton(() => RegisterForEventUseCase(locator()));
  locator.registerLazySingleton(() => GetMyEventsUseCase(locator()));
  locator.registerLazySingleton(() => WithdrawFromEventUseCase(locator()));
  locator.registerLazySingleton(() => CheckInToEventUseCase(locator()));
  locator.registerLazySingleton(() => GetContextualPriceUseCase(locator()));
  locator.registerLazySingleton(
    () => DeviceTokenRegistrar(
      locator<SessionRepository>(),
      locator<RegisterDeviceTokenUseCase>(),
    ),
  );
  // NFC use case registrations removed.

  // Settings Use Cases
  locator.registerLazySingleton(() => GetThemeModeUseCase(locator()));
  locator.registerLazySingleton(() => SetThemeModeUseCase(locator()));
  locator.registerLazySingleton(() => GetLocaleUseCase(locator()));
  locator.registerLazySingleton(() => SetLocaleUseCase(locator()));
  locator.registerLazySingleton(() => IsLanguageSelectedUseCase(locator()));
  locator.registerLazySingleton(
    () => CompleteLanguageSelectionUseCase(locator()),
  );
  locator.registerLazySingleton(() => IsThemeSelectedUseCase(locator()));
  locator.registerLazySingleton(() => CompleteThemeSelectionUseCase(locator()));
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
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    );
    await vm.initialize();
    return vm;
  });

  locator.registerFactory<PaymentHistoryViewModel>(
    () => PaymentHistoryViewModel(locator<GetFullPaymentHistoryUseCase>()),
  );

  locator.registerFactory<FamilyManagementViewModel>(
    () => FamilyManagementViewModel(
      getUserProfileUseCase: locator<GetUserProfileUseCase>(),
      getVerificationStatusUseCase: locator<GetVerificationStatusUseCase>(),
      enableFamilyFeatureUseCase: locator<EnableFamilyFeatureUseCase>(),
      verifyOtpUseCase: locator<VerifyOtpUseCase>(),
      requestFamilyAccountOtpUseCase: locator<RequestFamilyAccountOtpUseCase>(),
      getChildrenUseCase: locator<GetChildrenUseCase>(),
      addChildUseCase: locator<AddChildUseCase>(),
      removeChildUseCase: locator<RemoveChildUseCase>(),
      disableFamilyFeatureUseCase: locator<DisableFamilyFeatureUseCase>(),
    ),
  );

  // NFC ViewModel factory removed.

  // Wait for all async singletons before the app starts.
  await locator.allReady();
}
