# Unit Testing Report

This document provides a comprehensive overview of the testing state for the Bourgo Arena Mobile project. It is updated automatically to reflect the current test coverage and suite health.

## Overview

- **Total Test Files:** 70 (54 Unit / 15 Widget / 1 Other)
- **Total Individual Test Cases:** 328
- **Global Line Coverage:** 52.2%
- **Coverage by Layer:**
  - **Data Layer:** 84.8%
  - **Domain Layer:** 69.3%
  - **Core Layer:** 50.3%
  - **Presentation Layer:** 49.2%
- **Testing Stack:** Flutter Test, Mocktail, Checks

---

## Data Layer Detail

The data layer handles API communication, data mapping, and local persistence. It maintains the highest coverage in the project due to its critical role in data integrity.

### [COVERED]
- [activity_mapper.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/mappers/activity_mapper.dart)
- [course_mapper.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/mappers/course_mapper.dart)
- [notification_mapper.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/mappers/notification_mapper.dart)
- [reservation_mapper.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/mappers/reservation_mapper.dart)
- [time_slot_mapper.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/mappers/time_slot_mapper.dart)
- [user_mapper.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/mappers/user_mapper.dart)
- [activity_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/models/activity_model.dart)
- [child_profile_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/models/child_profile_model.dart)
- [course_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/models/course_model.dart)
- [notification_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/models/notification_model.dart)
- [reservation_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/models/reservation_model.dart)
- [time_slot_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/models/time_slot_model.dart)
- [user_profile_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/models/user_profile_model.dart)
- [api_activity_repository.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/repositories/api_activity_repository.dart)
- [api_auth_repository.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/repositories/api_auth_repository.dart)
- [api_course_repository.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/repositories/api_course_repository.dart)
- [api_notification_repository.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/repositories/api_notification_repository.dart)
- [api_reservation_repository.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/repositories/api_reservation_repository.dart)
- [api_user_repository.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/repositories/api_user_repository.dart)

### [UNTESTED]
- [api_error_handler.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/api/api_error_handler.dart) (71.4%)
- [api_exceptions.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/api/api_exceptions.dart) (62.5%)
- [api_client.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/api/api_client.dart) (57.8%)
- [local_session_repository.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/data/repositories/local_session_repository.dart) (55.8%)

---

## Domain Layer Detail

The domain layer contains pure business logic, entities, and use cases. It is independent of any infrastructure.

### [COVERED]
- [failure.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/core/failure.dart)
- [activity.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/entities/activity.dart)
- [get_activities_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/activity/get_activities_use_case.dart)
- [get_time_slots_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/activity/get_time_slots_use_case.dart)
- [complete_registration_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/auth/complete_registration_use_case.dart)
- [login_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/auth/login_use_case.dart)
- [logout_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/auth/logout_use_case.dart)
- [register_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/auth/register_use_case.dart)
- [request_family_account_otp_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/auth/request_family_account_otp_use_case.dart)
- [send_otp_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/auth/send_otp_use_case.dart)
- [update_password_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/auth/update_password_use_case.dart)
- [verify_otp_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/auth/verify_otp_use_case.dart)
- [cancel_booking_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/booking/cancel_booking_use_case.dart)
- [get_user_bookings_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/booking/get_user_bookings_use_case.dart)
- [make_reservation_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/booking/make_reservation_use_case.dart)
- [get_courses_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/course/get_courses_use_case.dart)
- [get_notifications_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/notification/get_notifications_use_case.dart)
- [get_locale_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/settings/get_locale_use_case.dart)
- [get_notifications_enabled_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/settings/get_notifications_enabled_use_case.dart)
- [get_theme_mode_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/settings/get_theme_mode_use_case.dart)
- [is_language_selected_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/settings/is_language_selected_use_case.dart)
- [set_locale_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/settings/set_locale_use_case.dart)
- [set_notifications_enabled_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/settings/set_notifications_enabled_use_case.dart)
- [set_theme_mode_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/settings/set_theme_mode_use_case.dart)
- [get_user_profile_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/user/get_user_profile_use_case.dart)
- [update_user_profile_use_case.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/usecases/user/update_user_profile_use_case.dart)

### [UNTESTED]
- [user.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/entities/user.dart) (97.9%)
- [child_profile.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/entities/child_profile.dart) (96.2%)
- [subscription.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/entities/subscription.dart) (60.0%)
- [notification.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/entities/notification.dart) (32.0%)
- [time_slot.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/entities/time_slot.dart) (25.0%)
- [course.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/entities/course.dart) (14.8%)
- [search_result.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/entities/search_result.dart) (11.8%)
- [reservation.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/domain/entities/reservation.dart) (8.0%)

---

## Core Layer Detail

The core layer includes shared utilities, dependency injection, and theme configurations.

### [COVERED]
*No files in the core layer have reached 100% coverage.*

### [UNTESTED]
- [result.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/core/utils/result.dart) (90.5%)
- [bourgo_theme.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/core/theme/bourgo_theme.dart) (77.3%)
- [locator.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/core/di/locator.dart) (1.7%)

---

## Presentation Layer Detail

The presentation layer includes view models, screens, and widgets. Coverage here reflects the extent of widget and view model testing.

### [COVERED]
- [login_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/login/viewmodels/login_view_model.dart)
- [otp_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/otp/otp_view_model.dart)
- [auth_background.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/widgets/auth_background.dart)
- [progress_stepper.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/booking/widgets/progress_stepper.dart)
- [activity_card.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/home/widgets/activity_card.dart)
- [ticker_strip.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/home/widgets/ticker_strip.dart)
- [notifications_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/notifications/notifications_view_model.dart)
- [settings_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/settings/viewmodels/settings_view_model.dart)

### [UNTESTED]
- [otp_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/otp/otp_screen.dart) (99.0%)
- [booking_flow_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/booking/booking_flow_screen.dart) (97.8%)
- [select_time_step.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/booking/steps/select_time_step.dart) (97.1%)
- [planning_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/planning/planning_view_model.dart) (96.8%)
- [today_course_card.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/home/widgets/today_course_card.dart) (96.4%)
- [profile_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/profile/profile_screen.dart) (96.3%)
- [auth_text_field.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/widgets/auth_text_field.dart) (96.1%)
- [auth_header.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/widgets/auth_header.dart) (96.0%)
- [course_card.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/planning/widgets/course_card.dart) (95.4%)
- [onboarding_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/onboarding/onboarding_screen.dart) (94.9%)
- [payment_step.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/booking/steps/payment_step.dart) (94.8%)
- [search_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/search/search_view_model.dart) (94.5%)
- [profile_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/profile/profile_view_model.dart) (94.4%)
- [home_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/home/home_screen.dart) (93.3%)
- [notifications_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/notifications/notifications_screen.dart) (93.3%)
- [login_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/login/login_screen.dart) (92.3%)
- [register_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/register/viewmodels/register_view_model.dart) (91.5%)
- [select_sport_step.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/booking/steps/select_sport_step.dart) (88.9%)
- [search_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/search/search_screen.dart) (88.0%)
- [register_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/register/register_screen.dart) (84.7%)
- [home_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/home/home_view_model.dart) (82.1%)
- [empty_state.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/common/empty_state.dart) (81.8%)
- [booking_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/booking/viewmodels/booking_view_model.dart) (77.9%)
- [settings_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/settings/settings_screen.dart) (77.4%)
- [brand_logo.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/common/widgets/brand_logo.dart) (75.0%)
- [planning_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/planning/planning_screen.dart) (70.0%)
- [family_member_widgets.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/common/widgets/family_member_widgets.dart) (16.7%)
- [offline_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/common/offline_screen.dart) (3.7%)
- [privacy_policy_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/settings/privacy_policy_screen.dart) (3.2%)
- [terms_of_service_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/settings/terms_of_service_screen.dart) (3.2%)
- [forgot_password_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/forgot_password/forgot_password_screen.dart) (2.4%)
- [new_password_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/new_password/new_password_screen.dart) (1.9%)
- [history_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/profile/history_screen.dart) (1.4%)
- [activities_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/activities/activities_screen.dart) (1.2%)
- [subscription_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/profile/subscription_screen.dart) (1.1%)
- [change_password_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/profile/change_password_screen.dart) (1.0%)
- [edit_profile_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/profile/edit_profile_screen.dart) (0.9%)
- [family_management_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/profile/family_management_screen.dart) (0.6%)
- [auth_state_notifier.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/auth_state_notifier.dart) (0.0%)
- [activities_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/activities/viewmodels/activities_view_model.dart) (0.0%)
- [reservation_card.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/activities/widgets/reservation_card.dart) (0.0%)
- [main_layout.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/main_layout.dart) (0.0%)
- [forgot_password_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/forgot_password/forgot_password_view_model.dart) (0.0%)
- [new_password_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/new_password/new_password_view_model.dart) (0.0%)
- [account_setup_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/register/account_setup_screen.dart) (0.0%)
- [family_onboarding_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/register/family_onboarding_screen.dart) (0.0%)
- [family_onboarding_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/register/viewmodels/family_onboarding_view_model.dart) (0.0%)
- [pin_setup_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/register/pin_setup_screen.dart) (0.0%)
- [verification_method_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/auth/register/verification_method_screen.dart) (0.0%)
- [booking_success_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/booking/booking_success_screen.dart) (0.0%)
- [not_found_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/common/not_found_screen.dart) (0.0%)
- [language_selection_screen.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/onboarding/language_selection_screen.dart) (0.0%)
- [change_password_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/profile/change_password_view_model.dart) (0.0%)
- [edit_profile_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/profile/edit_profile_view_model.dart) (0.0%)
- [family_management_view_model.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/profile/family_management_view_model.dart) (0.0%)
