# Project Architecture & Structure

## Overview
**Bourgo Arena Mobile** is a premium Flutter application designed for sports arena management. It utilizes a **Layered MVVM (Model-View-ViewModel)** architecture influenced by **Clean Architecture** principles to ensure high maintainability, testability, and scalability. The system is designed to integrate seamlessly with a **Laravel API** backend.

---

## Architecture Analysis

### Architectural Style: Layered Modular Monolith
The application is structured into four distinct layers with a strict unidirectional dependency flow. The **Domain** layer sits at the center, representing the "stable" core of the application, while the **Data** and **Presentation** layers depend on it.

### The Four Layers

#### 1. Domain Layer (The Core)
The most stable layer, containing pure business logic. It has zero dependencies on any other layer or external framework.
- **Entities**: Pure Dart objects (`User`, `Activity`, `Reservation`) representing business data.
- **Repositories (Interfaces)**: Abstract definitions of data operations (e.g., `AuthRepository`, `ActivityRepository`).
- **Use Cases**: Single-responsibility classes (`LoginUseCase`, `GetActivitiesUseCase`) that encapsulate specific business logic and orchestrate repositories.

#### 2. Data Layer (Infrastructure)
Responsible for data retrieval, persistence, and external integrations.
- **Models (DTOs)**: Data Transfer Objects used for JSON serialization (`@JsonSerializable`).
- **Repository Implementations**: Concrete classes that implement Domain interfaces (e.g., `ApiAuthRepository`, `ApiActivityRepository`), orchestrating data from the **Laravel API**.
- **Mappers**: Pure functions that transform DTOs to Domain Entities, isolating the app from backend schema changes.
- **API Clients**: A central `ApiClient` handling base HTTP logic (headers, tokens, error handling).
- **Services (Transitionary)**: Legacy services (e.g., `AuthService`, `DataService`) that act as state managers or bridges between old UI logic and new Clean Architecture components.

#### 3. Presentation Layer (UI & State)
Handles the user interface and reactive state management.
- **Widgets/Screens**: Flutter UI components built with Material 3.
- **ViewModels**: Manage screen state and handle user interactions. They are currently being refactored to invoke **Use Cases** instead of services directly.
- **Common Widgets**: Reusable UI components shared across features (e.g., `BrandLogo`, `AuthBackground`).

#### 4. Core Layer (Shared)
Cross-cutting concerns and infrastructure code.
- **DI (GetIt)**: Centralized Dependency Injection implemented in `lib/core/di/locator.dart`.
- **Config**: Application configuration (e.g., `AppConfig.baseUrl`) managed through environment variables.
- **Theme**: Premium Material 3 design system with customized tokens and `ThemeExtension`.
- **Utils**: Generic utilities like formatting and common constants.

---

## Design Pattern Identification

The following patterns are consistently applied across the codebase:

### 1. Repository Pattern
Abstracts the data source from the business logic. All data interaction flows through concrete implementations that implement domain interfaces.

### 2. Dependency Injection (Service Locator)
Managed by `package:get_it`. It provides a centralized way to resolve dependencies, promoting decoupling and easier testing.

### 3. Observer Pattern
Implemented via Flutter's `ChangeNotifier`, `ValueNotifier`, and `ListenableBuilder`. ViewModels notify the UI of state changes.

### 4. Command / Use Case Pattern
Encapsulates a single business action into a dedicated class. This makes the code self-documenting and testable in isolation.

### 5. Result Pattern (Standard)
The intention is to have all asynchronous operations return a `Result<T>` object to force explicit error handling.

### 6. Adapter / Mapper Pattern
Explicit mappers transform raw API data into clean domain entities, isolating the app from backend schema changes.

### 7. Facade Pattern
`DataService` acts as a facade to provide compatibility for ViewModels during the migration to Clean Architecture.

---

## Folder Structure

```text
lib/
├── core/                # Shared utilities, constants, and DI
│   ├── config/          # Centralized configuration (AppConfig)
│   ├── di/              # Dependency Injection setup (GetIt)
│   ├── theme/           # Material 3 Theme (BourgoTheme)
│   └── utils/           # Shared utilities
├── data/                # Data retrieval and implementation
│   ├── api/             # API client
│   ├── mappers/         # DTO-to-Entity converters
│   ├── models/          # @JsonSerializable DTOs
│   ├── repositories/    # Concrete repository implementations (API)
│   └── services/        # Logic services and bridge facades
├── domain/              # Pure business logic and interfaces
│   ├── entities/        # Pure business objects
│   ├── repositories/    # Abstract interfaces
│   └── usecases/        # Single-responsibility logic
├── presentation/        # UI layer organized by feature
│   ├── auth/            # Login, Register, Forgot Password
│   ├── onboarding/      # Welcome, Language Selection
│   ├── profile/         # Profile, Family Management
│   ├── home/            # Dashboard, Today's schedule
│   └── common/          # Reusable UI components
├── l10n/                # Localization (ARB files)
├── main.dart            # Entry point
└── router.dart          # GoRouter configuration
```

---

## Tech Stack & Integration

- **Framework**: Flutter (Dart)
- **Navigation**: `go_router` for declarative routing and deep linking.
- **State Management**: `ChangeNotifier` + `ValueNotifier` (Flutter built-ins).
- **Networking**: `http` package with a custom `ApiClient`.
- **Serialization**: `json_serializable` for type-safe JSON handling.
- **Dependency Injection**: `get_it`.
- **Typography**: `google_fonts`.
- **Local Storage**: `shared_preferences` for persistence (e.g., settings, tokens).

---

## Quality & Styling

- **Linting**: Strict rules defined in `analysis_options.yaml` and `GEMINI.md`.
- **Formatting**: `dart format` enforced across the project.
- **Theming**: Strict adherence to Material 3 and `ColorScheme` tokens. No hardcoded colors.
- **Documentation**: `///` doc comments required for all public APIs.

---

## Data Flow

1. **User action** in a Screen.
2. **ViewModel method** is called.
3. **Use Case** is invoked (or Service during transition).
4. **Repository** provides data (mapped from DTO to Entity).
5. **UI update** triggered via `notifyListeners()`.

---

For architectural rationale and decisions, see [DECISIONS.md](DECISIONS.md).
