# Bourgo Arena Mobile - Product Backlog

Based on an audit of the local codebase architecture, domain use cases, data repositories, and presentation screens, here is the current Product Backlog of implemented features.

| ID | Feature/Module | User Story | Technical Acceptance Criteria | Implementation Status |
|----|----------------|------------|-------------------------------|-----------------------|
| **US001** | Authentication | As a user, I want to register a new account so I can use the application. | `RegisterUseCase` implemented, connected to `ApiAuthRepository`. UI has Account Setup, Verification, and PIN Setup. | Fully Implemented |
| **US002** | Authentication | As a user, I want to log in using my credentials so I can access my profile. | `LoginUseCase` implemented, returning auth tokens. Handled in `LoginViewModel` and `LoginScreen`. | Fully Implemented |
| **US003** | Authentication | As a user, I want to reset my password using OTP so I can regain access if I forget it. | `ForgotPasswordUseCase`, `SendOtpUseCase`, `VerifyOtpUseCase`, `ResetPasswordUseCase` implemented. `OtpScreen` & `NewPasswordScreen` connected. | Fully Implemented |
| **US004** | Authentication | As a user, I want to set up an account PIN for quick secure access. | `PinSetupScreen` present in the registration flow. | Fully Implemented |
| **US005** | Family Management | As a parent, I want to add and manage my children's profiles so I can book activities for them. | `AddChildUseCase`, `GetChildrenUseCase`, `UpdateChildUseCase` implemented in `ApiFamilyRepository`. `AddEditChildScreen` and `ManageChildrenScreen` UI exist. | Fully Implemented |
| **US006** | Booking | As a user, I want to book an activity/sport time slot so I can secure my reservation. | Multi-step booking flow (`BookingFlowScreen`, `SelectSportStep`, `SelectTimeStep`, `SelectMemberStep`, `PaymentStep`) implemented. `MakeReservationUseCase` connected. | Fully Implemented |
| **US007** | Booking | As a user, I want to view and cancel my upcoming bookings so I can manage my schedule. | `GetUserBookingsUseCase` and `CancelBookingUseCase` present in Domain layer. | Fully Implemented |
| **US008** | Activities & Planning | As a user, I want to view available courses and activities on a planning calendar. | `GetActivitiesUseCase`, `GetCoursesUseCase` in `ApiCourseRepository`/`ApiActivityRepository`. `PlanningScreen` UI and `CourseCard` widget present. | Fully Implemented |
| **US009** | User Profile | As a user, I want to edit my profile details and view access history. | `UpdateUserProfileUseCase`, `GetAccessHistoryUseCase` implemented. `EditProfileScreen` & `HistoryScreen` available. | Fully Implemented |
| **US010** | Subscriptions | As a user, I want to manage my active subscriptions. | `GetActiveSubscriptionUseCase` and `ApiSubscriptionRepository` implemented. `SubscriptionManagementScreen` present. | Fully Implemented |
| **US011** | Loyalty & Rewards | As a user, I want to see my loyalty tier and projected points so I can track my rewards. | `GetMemberTierUseCase`, `ProjectPointsUseCase` implemented. `LoyaltyDashboardScreen` and `TierBadge` widgets created. | Fully Implemented |
| **US012** | Notifications | As a user, I want to receive and read notifications about my bookings and account. | `GetNotificationsUseCase`, `MarkNotificationsReadUseCase` implemented. `NotificationsScreen` available. | Fully Implemented |
| **US013** | Settings | As a user, I want to adjust app settings (language, theme, notifications) so it suits my preferences. | `SetLocaleUseCase`, `SetThemeModeUseCase`, `LanguageSelectionScreen`, `SettingsScreen` implemented. | Fully Implemented |
| **US014** | Search | As a user, I want to search for activities or courses so I can quickly find what I want. | `SearchUseCase` in `ApiSearchRepository` implemented. `SearchScreen` UI created. | Fully Implemented |
