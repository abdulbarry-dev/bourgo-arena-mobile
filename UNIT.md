UNIT Tests — Current State (auto-generated)
=========================================

**Overview**
- **Total test files:** 43
- **Unit test files:** 39
- **Widget test files:** 3
- **Other test files:** 1
- **Total test cases (last run):** 190
- **Last full run (flutter test --reporter=expanded):** 00:12 +190: All tests passed!

**Test Tree (files)**
- [test/unit/data/mappers/activity_mapper_test.dart](test/unit/data/mappers/activity_mapper_test.dart)
- [test/unit/data/mappers/course_mapper_test.dart](test/unit/data/mappers/course_mapper_test.dart)
- [test/unit/data/mappers/mapper_test_fixtures.dart](test/unit/data/mappers/mapper_test_fixtures.dart)
- [test/unit/data/mappers/notification_mapper_test.dart](test/unit/data/mappers/notification_mapper_test.dart)
- [test/unit/data/mappers/reservation_mapper_test.dart](test/unit/data/mappers/reservation_mapper_test.dart)
- [test/unit/data/mappers/time_slot_mapper_test.dart](test/unit/data/mappers/time_slot_mapper_test.dart)
- [test/unit/data/mappers/user_mapper_test.dart](test/unit/data/mappers/user_mapper_test.dart)
- [test/unit/data/repositories/api_activity_repository_test.dart](test/unit/data/repositories/api_activity_repository_test.dart)
- [test/unit/data/repositories/api_auth_repository_test.dart](test/unit/data/repositories/api_auth_repository_test.dart)
- [test/unit/data/repositories/api_course_repository_test.dart](test/unit/data/repositories/api_course_repository_test.dart)
- [test/unit/data/repositories/api_notification_repository_test.dart](test/unit/data/repositories/api_notification_repository_test.dart)
- [test/unit/data/repositories/api_reservation_repository_test.dart](test/unit/data/repositories/api_reservation_repository_test.dart)
- [test/unit/data/repositories/api_user_repository_test.dart](test/unit/data/repositories/api_user_repository_test.dart)
- [test/unit/data/repositories/local_session_repository_test.dart](test/unit/data/repositories/local_session_repository_test.dart)
- [test/unit/data/repositories/repository_test_fixtures.dart](test/unit/data/repositories/repository_test_fixtures.dart)
- [test/unit/domain/usecases/activity/get_activities_use_case_test.dart](test/unit/domain/usecases/activity/get_activities_use_case_test.dart)
- [test/unit/domain/usecases/activity/get_time_slots_use_case_test.dart](test/unit/domain/usecases/activity/get_time_slots_use_case_test.dart)
- [test/unit/domain/usecases/auth/complete_registration_use_case_test.dart](test/unit/domain/usecases/auth/complete_registration_use_case_test.dart)
- [test/unit/domain/usecases/auth/login_use_case_test.dart](test/unit/domain/usecases/auth/login_use_case_test.dart)
- [test/unit/domain/usecases/auth/logout_use_case_test.dart](test/unit/domain/usecases/auth/logout_use_case_test.dart)
- [test/unit/domain/usecases/auth/register_use_case_test.dart](test/unit/domain/usecases/auth/register_use_case_test.dart)
- [test/unit/domain/usecases/auth/request_family_account_otp_use_case_test.dart](test/unit/domain/usecases/auth/request_family_account_otp_use_case_test.dart)
- [test/unit/domain/usecases/auth/send_otp_use_case_test.dart](test/unit/domain/usecases/auth/send_otp_use_case_test.dart)
- [test/unit/domain/usecases/auth/update_password_use_case_test.dart](test/unit/domain/usecases/auth/update_password_use_case_test.dart)
- [test/unit/domain/usecases/auth/verify_otp_use_case_test.dart](test/unit/domain/usecases/auth/verify_otp_use_case_test.dart)
- [test/unit/domain/usecases/booking/cancel_booking_use_case_test.dart](test/unit/domain/usecases/booking/cancel_booking_use_case_test.dart)
- [test/unit/domain/usecases/booking/get_user_bookings_use_case_test.dart](test/unit/domain/usecases/booking/get_user_bookings_use_case_test.dart)
- [test/unit/domain/usecases/booking/make_reservation_use_case_test.dart](test/unit/domain/usecases/booking/make_reservation_use_case_test.dart)
- [test/unit/domain/usecases/course/get_courses_use_case_test.dart](test/unit/domain/usecases/course/get_courses_use_case_test.dart)
- [test/unit/domain/usecases/notification/get_notifications_use_case_test.dart](test/unit/domain/usecases/notification/get_notifications_use_case_test.dart)
- [test/unit/domain/usecases/settings/get_locale_use_case_test.dart](test/unit/domain/usecases/settings/get_locale_use_case_test.dart)
- [test/unit/domain/usecases/settings/get_notifications_enabled_use_case_test.dart](test/unit/domain/usecases/settings/get_notifications_enabled_use_case_test.dart)
- [test/unit/domain/usecases/settings/is_language_selected_use_case_test.dart](test/unit/domain/usecases/settings/is_language_selected_use_case_test.dart)
- [test/unit/domain/usecases/settings/set_locale_use_case_test.dart](test/unit/domain/usecases/settings/set_locale_use_case_test.dart)
- [test/unit/domain/usecases/settings/set_notifications_enabled_use_case_test.dart](test/unit/domain/usecases/settings/set_notifications_enabled_use_case_test.dart)
- [test/unit/domain/usecases/usecase_test_fixtures.dart](test/unit/domain/usecases/usecase_test_fixtures.dart)
- [test/unit/domain/usecases/user/get_user_profile_use_case_test.dart](test/unit/domain/usecases/user/get_user_profile_use_case_test.dart)
- [test/unit/domain/usecases/user/update_user_profile_use_case_test.dart](test/unit/domain/usecases/user/update_user_profile_use_case_test.dart)
- [test/unit/presentation/viewmodels/login_view_model_test.dart](test/unit/presentation/viewmodels/login_view_model_test.dart)
- [test/widget/auth/login_screen_test.dart](test/widget/auth/login_screen_test.dart)
- [test/widget/home/home_screen_test.dart](test/widget/home/home_screen_test.dart)
- [test/widget/profile/profile_screen_test.dart](test/widget/profile/profile_screen_test.dart)
- [test/widget_test.dart](test/widget_test.dart)

**By Layer (classes / groups & exact test names)**

Data — Mappers
- `ActivityMapper`: see [test/unit/data/mappers/activity_mapper_test.dart](test/unit/data/mappers/activity_mapper_test.dart) (group: `ActivityMapper`).
- `CourseMapper`: see [test/unit/data/mappers/course_mapper_test.dart](test/unit/data/mappers/course_mapper_test.dart) (group: `CourseMapper`).
- `NotificationMapper`: see [test/unit/data/mappers/notification_mapper_test.dart](test/unit/data/mappers/notification_mapper_test.dart) (group: `NotificationMapper`).
- `ReservationMapper`: see [test/unit/data/mappers/reservation_mapper_test.dart](test/unit/data/mappers/reservation_mapper_test.dart) (group: `ReservationMapper`).
- `TimeSlotMapper`: see [test/unit/data/mappers/time_slot_mapper_test.dart](test/unit/data/mappers/time_slot_mapper_test.dart) (group: `TimeSlotMapper`).
- `UserMapper`: see [test/unit/data/mappers/user_mapper_test.dart](test/unit/data/mappers/user_mapper_test.dart) (group: `UserMapper`).

Data — Repositories
- `ApiActivityRepository`: groups in [test/unit/data/repositories/api_activity_repository_test.dart](test/unit/data/repositories/api_activity_repository_test.dart) — `ApiActivityRepository`, `getActivities`, `getActivityById`, `getTimeSlots`.
- `ApiAuthRepository`: groups in [test/unit/data/repositories/api_auth_repository_test.dart](test/unit/data/repositories/api_auth_repository_test.dart) — `ApiAuthRepository`, `login`, `logout`, `register`, `sendOtp`, `verifyOtp`, `requestFamilyAccountOtp`, `completeRegistration`, `updatePassword`, `getToken`.
- `ApiCourseRepository`: [test/unit/data/repositories/api_course_repository_test.dart](test/unit/data/repositories/api_course_repository_test.dart) (group: `ApiCourseRepository`).
- `ApiNotificationRepository`: [test/unit/data/repositories/api_notification_repository_test.dart](test/unit/data/repositories/api_notification_repository_test.dart) (group: `ApiNotificationRepository`).
- `ApiReservationRepository`: [test/unit/data/repositories/api_reservation_repository_test.dart](test/unit/data/repositories/api_reservation_repository_test.dart) (groups: `ApiReservationRepository`, `getReservations`, `makeReservation`, `cancelReservation`).
- `ApiUserRepository`: [test/unit/data/repositories/api_user_repository_test.dart](test/unit/data/repositories/api_user_repository_test.dart) (groups: `ApiUserRepository`, `getUserProfile`, `updateUserProfile`).
- `LocalSessionRepository`: [test/unit/data/repositories/local_session_repository_test.dart](test/unit/data/repositories/local_session_repository_test.dart) (groups: `LocalSessionRepository`, `auth token storage`, `theme preferences`, `locale and onboarding`, `notification preferences`).

Domain — Use Cases
- Each use case has a dedicated unit test under `test/unit/domain/usecases/...`. Examples:
  - `GetCoursesUseCase`: see [test/unit/domain/usecases/course/get_courses_use_case_test.dart](test/unit/domain/usecases/course/get_courses_use_case_test.dart) (test names: "GetCoursesUseCase returns the course list on success", "GetCoursesUseCase propagates repository failures unchanged", "GetCoursesUseCase returns empty lists unchanged").
  - Settings use cases: see `test/unit/domain/usecases/settings/` (multiple groups: `GetLocaleUseCase`, `GetNotificationsEnabledUseCase`, `IsLanguageSelectedUseCase`, `SetLocaleUseCase`, `SetNotificationsEnabledUseCase`).
  - User use cases: `GetUserProfileUseCase`, `UpdateUserProfileUseCase` (see corresponding files).

Presentation — ViewModels & Widgets
- `LoginViewModel` unit tests (three exact tests):
  - [test/unit/presentation/viewmodels/login_view_model_test.dart](test/unit/presentation/viewmodels/login_view_model_test.dart)
  - Tests: `does not call use case when form is not valid`; `calls use case and leaves isLoading false on success`; `shows SnackBar with failure message on failure`.
- Widget tests (examples):
  - [test/widget/auth/login_screen_test.dart](test/widget/auth/login_screen_test.dart)
    - Tests: `login button disabled when form invalid`; `calls login use case on valid form`; `shows SnackBar on failure`.
  - [test/widget/home/home_screen_test.dart](test/widget/home/home_screen_test.dart)
    - Tests: `initial render shows key UI elements`; `loading state shows CircularProgressIndicator`; `when use cases return failure, empty lists are shown`.
  - [test/widget/profile/profile_screen_test.dart](test/widget/profile/profile_screen_test.dart)
    - Tests: `initial render shows user name when profile loads`; `loading state shows CircularProgressIndicator`; `error state displays loading error message`; `logout button is present and tappable`.

**Mocks & Shared Fixtures**
- Shared fixtures:
  - [test/unit/data/mappers/mapper_test_fixtures.dart](test/unit/data/mappers/mapper_test_fixtures.dart)
  - [test/unit/data/repositories/repository_test_fixtures.dart](test/unit/data/repositories/repository_test_fixtures.dart)
  - [test/unit/domain/usecases/usecase_test_fixtures.dart](test/unit/domain/usecases/usecase_test_fixtures.dart)
- Common mock classes are declared across tests (examples): `MockApiClient`, `MockSessionRepository`, `MockActivityRepository`, `MockAuthRepository`, `MockReservationRepository`, `MockCourseRepository`, `MockNotificationRepository`, `MockUserRepository`, `MockLoginUseCase`, `MockGetActivities`, `MockGetCourses`, `MockGetProfile`, `MockLogout`, `MockSettingsViewModel`, `MockAuthStateNotifier`.

**How to run (commands)**
- Run full suite: `flutter test --reporter=expanded` (captures expanded output and final summary line shown above).
- Run with coverage: `flutter test --coverage` then `genhtml coverage/lcov.info -o coverage/html` (requires `lcov` / `genhtml`).
- Run a single file: `flutter test <path-to-test-file>` (e.g. `flutter test test/widget/profile/profile_screen_test.dart`).

**Coverage gaps / priorities**
- Overall line coverage (last run): ~24.2% (coverage/lcov.info generated previously).
- Highest-priority gaps (low or 0% coverage) — recommended focus:
  - Presentation layer: many viewmodels and state notifiers are untested (e.g. settings, profile, booking, search viewmodels). Start by adding pure-Dart ViewModel tests.
  - `lib/data/api/api_client.dart` and related API plumbing: add unit tests or integration-style mocks for request/response mapping.
  - Domain entities with low coverage (user, child_profile, notification, time_slot) — add entity edge-case tests and mappers.

**Conventions (brief)**
- Prefer pure-Dart tests for domain + data layers (`package:test`). Use `flutter_test` only when widget bindings or `WidgetTester` are needed.
- Reset DI between widget tests: `await locator.reset()` in `setUp()` and re-register mocks.
- For widget tests that load `NetworkImage`, set `HttpOverrides.global` to a fake HttpClient that returns a 1x1 PNG (see existing widget tests for an example).

If you'd like, I can now:
- commit this updated `UNIT.md`,
- expand the per-file test lists to include every single test name (I can parse each test file and extract all `test()`/`testWidgets()` strings), or
- start adding tests for the highest-priority coverage gaps. Which would you prefer next?
