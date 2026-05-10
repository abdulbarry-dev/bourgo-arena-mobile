# PRODUCT BACKLOG — Bourgo Arena

This document provides a comprehensive analysis and reverse-engineered product backlog for the Bourgo Arena mobile application. It is intended for internal documentation, project maintenance, and future development planning.

---

## 1. Product Overview
### Application Summary
**Bourgo Arena** is a premium sports center management application designed to facilitate activity discovery, court/slot booking, course scheduling, and family account management for a high-end athletic facility.

### Primary Purpose
To provide a seamless, mobile-first interface for members to interact with the arena's services, manage their athletic commitments, and oversee their family's participation in various sports programs.

### Core Value Proposition
- **Convenience:** Instant booking and scheduling from anywhere.
- **Family Integration:** Unique ability to link child profiles and manage multiple users under one parent account.
- **Personalization:** Tailored planning and notification systems based on user interests and subscriptions.
- **Premium Experience:** High-fidelity UI with smooth transitions and a focus on visual excellence.

### Target Users
- **Active Members:** Individuals looking to book sports facilities (Football, Padel, Tennis, etc.).
- **Parents:** Families managing children's sports academies and courses.
- **Casual Athletes:** Users looking for one-off sessions or local sports events.

### Inferred Business Goals
- Increase facility utilization through streamlined booking.
- Build community engagement via structured courses and academies.
- Enhance user retention through a robust subscription and planning model.
- Digitize the entire customer journey from registration to payment.

---

## 2. Application Architecture
### Folder Structure Explanation
The project follows a **Layered Clean Architecture** combined with **MVVM** in the presentation layer:
- `lib/core/`: Cross-cutting concerns (DI, Theme, Constants, Config).
- `lib/domain/`: Business logic core (Entities, Use Cases, Repository Interfaces).
- `lib/data/`: Implementation details (Models/DTOs, Repository Impls, API Client, Mappers).
- `lib/presentation/`: UI layer (Screens, ViewModels, Feature-specific Widgets).
- `lib/l10n/`: Localization files.

### Architectural Pattern
- **Clean Architecture:** Strict separation between domain logic and external dependencies.
- **MVVM (Model-View-ViewModel):** Presentation layer logic is isolated in ViewModels, which use ChangeNotifiers to communicate with Widgets.

### State Management Approach
- **ListenableBuilder / ValueListenableBuilder:** Primary reactive builders.
- **ChangeNotifier / ValueNotifier:** State containers in ViewModels.
- **AuthStateNotifier:** Global singleton for managing authentication state across the app.

### Dependency Overview
- **Routing:** `go_router` for declarative navigation.
- **DI:** `get_it` for service locator.
- **Networking:** `http` with a custom `ApiClient`.
- **Serialization:** `json_serializable` for DTOs.
- **UI:** `google_fonts`, `material_symbols_icons`.

### Environment Setup
- Uses `AppConfig` for base URL and environment-specific flags.
- Dependencies are initialized in `initLocator()` in `main.dart`.

---

## 3. Feature Inventory

| Feature Name | Description | Related Files/Screens | Status |
|:---|:---|:---|:---:|
| **Authentication** | Login, Registration (Multi-step), OTP Verification, Password Recovery. | `lib/presentation/auth/` | Complete |
| **Profile Management** | View/Edit profile, Change Password, Avatar updates. | `lib/presentation/profile/` | Complete |
| **Family Accounts** | Linking family members, Managing child profiles. | `lib/presentation/profile/family_management_screen.dart` | Complete |
| **Activity Catalog** | Browsing sports categories and specific activities. | `lib/presentation/activities/` | Complete |
| **Booking System** | Time slot selection, Participant selection, Payment method. | `lib/presentation/booking/` | Complete |
| **Planning/Calendar** | Weekly view of personal courses and bookings. | `lib/presentation/planning/` | Complete |
| **Notifications** | List of system and activity notifications. | `lib/presentation/notifications/` | Complete |
| **Search** | Global search for activities and courses. | `lib/presentation/search/` | Complete |
| **Settings** | Theme switching (Light/Dark), Language selection, Legal docs. | `lib/presentation/settings/` | Complete |
| **Offline Mode** | Graceful handling of network loss. | `lib/presentation/common/offline_screen.dart` | Complete |

---

## 4. Screens & Navigation
### Navigation Flow
1. **Bootstrap:** `LanguageSelectionScreen` (if first run) -> `OnboardingScreen`.
2. **Auth Flow:** `LoginScreen` or `RegisterScreen` -> `OtpScreen` -> `AccountSetupScreen`.
3. **Main App:** `MainLayout` (Scaffold with BottomNav) -> `HomeScreen`, `PlanningScreen`, `SubscriptionScreen`, `HistoryScreen`.
4. **Modals/Overlays:** `SearchScreen`, `NotificationsScreen`, `SettingsScreen`.

### Route Structure (GoRouter)
- `/`: Onboarding (or redirect to Login/Home).
- `/login`: Login screen.
- `/register`: Multi-step registration entry.
- `/home`: Primary dashboard.
- `/booking`: Dynamic booking flow.
- `/planning`: Calendar view.
- `/family-management`: Child/Family linked accounts.

### Guards & Redirects
- **Auth Guard:** Redirects to `/login` if `AuthStateNotifier.isAuthenticated` is false.
- **First-Run Guard:** Redirects to `/language-selection` if no locale is stored.
- **Auth Bypass:** Redirects authenticated users from `/login` to `/home`.

---

## 5. User Flows
### Authentication Flow
`Entry` -> `Phone/Email Input` -> `OTP Verification` -> `Profile Details` -> `PIN Setup` -> `Success`.

### Booking Workflow
`Activity Select` -> `Participant Select (Self/Child)` -> `Time Slot Select` -> `Payment Method` -> `Confirmation`.

### Family Management
`Profile` -> `Family Management` -> `Add Child` -> `Input Details` -> `Update List`.
`Profile` -> `Family Management` -> `Link Account` -> `Request OTP` -> `Verify`.

---

## 6. Backend & Integrations
### API Strategy
- **Base URL:** Defined in `AppConfig`.
- **Client:** `ApiClient` handles Bearer tokens, JSON encoding, and common status code mapping.
- **Contracts:** Mapped through `Mappers` from `Data` to `Domain` layers.

### Third-Party SDKs
- **Google Fonts:** Dynamic font loading.
- **Material Symbols:** Consistent icon set.
- **Shared Preferences:** Persistent local storage for session and settings.

---

## 7. Data Layer
### Models & Entities
- **Entities:** Immutable business objects (e.g., `User`, `Activity`, `Reservation`).
- **Models:** `@JsonSerializable` DTOs (e.g., `UserProfileModel`, `ReservationModel`).
- **Mappers:** Static conversion logic between Models and Entities.

### Persistence & Caching
- **Session:** `LocalSessionRepository` manages tokens and user JSON in `SharedPreferences`.
- **Settings:** `SettingsRepository` manages theme/locale preferences.
- **Volatile Cache:** No specific persistent cache layer detected; relies on ViewModel state.

---

## 8. Technical Debt
- **Logic in ViewModels:** Some ViewModels (e.g., `HomeViewModel`) carry heavy initialization logic that could be further abstracted into Use Cases.
- **Large Widgets:** Screens like `HomeScreen` and `BookingFlowScreen` contain complex nested widgets; while extracted into private classes, some are still quite large (> 100 lines).
- **Hardcoded Strings:** While localized, some error messages in API handlers might still be hardcoded in English.
- **Implicit Dependencies:** Occasional direct access to `locator<T>` inside Widgets instead of passing through constructors.

---

## 9. Bugs & Risk Areas
- **State Inconsistency:** If an API call fails during a multi-step flow (e.g., Booking), the state might not always revert cleanly without a manual "reset" logic.
- **Concurrency:** Rapidly tapping buttons during async operations (e.g., `addChildFromForm`) might lead to duplicate requests if loading states aren't perfectly guarded.
- **Token Expiry:** The app handles 401 errors by throwing an exception, but a global interceptor for auto-logout or token refresh is a future risk area.

---

## 10. UX/UI Improvements
- **Micro-Animations:** Enhance page transitions and list item loading with subtle fades/slides.
- **Skeleton Loaders:** Replace generic `CircularProgressIndicator` with shimmer effects for activity cards.
- **Haptic Feedback:** Add subtle haptics on successful bookings and button presses.
- **Empty States:** Ensure all lists (Bookings, Notifications) have the beautiful `EmptyState` widget implemented.

---

## 11. Security Review
- **Secret Storage:** Ensure the API Base URL is not hardcoded but comes from `--dart-define` (currently in `AppConfig`).
- **Insecure Storage:** Sensitive user data (beyond token) should ideally move to `flutter_secure_storage` instead of standard `SharedPreferences`.
- **Input Validation:** Strengthen client-side validation for PIN and Password formats.

---

## 12. Performance Optimization
- **Widget Rebuilds:** Audit `ListenableBuilder` placements to ensure only necessary subtrees rebuild.
- **Image Optimization:** Implement lazy loading and caching for activity images.
- **List Performance:** Ensure `ListView.builder` is used for all dynamic lists (confirmed for most, need to check Search).

---

## 13. Suggested Refactors
- **Feature-Based Modularization:** Move from a flat architecture to a per-feature directory structure (e.g., `lib/features/auth/presentation/...`).
- **Interceptor Pattern:** Implement an `Interceptor` for the `http` client to handle tokens and logging more elegantly than manual header injection.

---

## 14. Missing Features
- **Real-time Notifications:** Integration with Firebase Cloud Messaging (FCM) is implied by the `Notification` feature but not yet visible in native setup.
- **Payments Integration:** `paymentMethodWalletId` exists as a constant, but the actual Stripe/PayPal gateway integration is pending.
- **Social Sharing:** Sharing activity links or booking successes.

---

## 15. Testing Assessment
- **Current Status:** High coverage for domain and data layers. Unit tests for major ViewModels (Login, Profile, Family).
- **Missing:** Comprehensive Integration tests (E2E) using `integration_test` package.
- **Priority:** Add Golden Tests for UI consistency across different screen sizes.

---

## 16. Product Roadmap
### MVP (Completed)
- Core Auth & Onboarding.
- Activity Discovery.
- Simple Slot Booking.
- Basic Profile & Settings.

### Short-Term (Next 3 Months)
- Family Account linking via OTP.
- Notification center fully wired to push service.
- Improved Search & Filter logic.

### Mid-Term (Next 6 Months)
- Integrated Payment Gateway.
- Digital Membership Card (QR).
- User Levels & Rewards.

---

## 17. Agile Backlog

### Epic: Family Connectivity (High Priority)
| ID | Title | User Story | Priority | Complexity |
|:---|:---|:---|:---:|:---:|
| FAM-01 | Add Child Profile | As a parent, I want to add a child profile so I can book courses for them. | High | 5 |
| FAM-02 | Link Existing Account | As a user, I want to link my child's existing account via OTP for shared management. | Medium | 8 |

### Epic: Booking Excellence (High Priority)
| ID | Title | User Story | Priority | Complexity |
|:---|:---|:---|:---:|:---:|
| BOK-01 | Multi-Participant Booking | As a user, I want to book a slot for myself and my children in one transaction. | High | 8 |
| BOK-02 | Booking Modification | As a user, I want to cancel or reschedule my booking at least 24h before. | Medium | 5 |

### Epic: User Engagement (Medium Priority)
| ID | Title | User Story | Priority | Complexity |
|:---|:---|:---|:---:|:---:|
| ENG-01 | Favorites | As a user, I want to "favorite" an activity for quick access from the home screen. | Low | 3 |
| ENG-02 | Notification Preferences | As a user, I want to toggle specific types of notifications (Booking, News). | Medium | 3 |

---

## 18. Release Planning
- **Phase 1 (Alpha):** Internal testing with mock data (Current State).
- **Phase 2 (Beta):** Staging environment with Laravel backend integration.
- **Phase 3 (Production):** App Store & Play Store deployment.

### Deployment Checklist
- [ ] Run `dart analyze` and ensure 0 issues.
- [ ] Verify all tests pass (`flutter test`).
- [ ] Check for hardcoded API secrets.
- [ ] Generate launcher icons.
- [ ] Perform build size audit (`flutter build apk --analyze-size`).
