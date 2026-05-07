# Project Architecture & Structure

## Overview
**Bourgo Arena Mobile** is a premium Flutter application designed for sports arena management. It utilizes a **Layered MVVM (Model-View-ViewModel)** architecture influenced by **Clean Architecture** principles to ensure high maintainability, testability, and scalability.

---

## Architecture Analysis

### Architectural Style: Layered Modular Monolith
The application is structured into four distinct layers with a strict unidirectional dependency flow. The **Domain** layer sits at the center, representing the "stable" core of the application, while the **Data** and **Presentation** layers depend on it.

### The Four Layers

#### 1. Domain Layer (The Core)
The most stable layer, containing pure business logic. It has zero dependencies on any other layer or external framework.
- **Entities**: Plain Dart objects (`User`, `Activity`) representing business data.
- **Repository Interfaces**: Abstract definitions of data operations.
- **Use Cases**: Single-responsibility classes (`LoginUseCase`) that encapsulate specific business logic.

#### 2. Data Layer (Infrastructure)
Responsible for data retrieval, persistence, and external integrations.
- **Models (DTOs)**: Data Transfer Objects used for JSON serialization (`@JsonSerializable`).
- **Repository Implementations**: Concrete classes that implement Domain interfaces, orchestrating data from APIs or Mock servers.
- **Mappers**: Pure functions that convert DTOs to Domain Entities, ensuring the rest of the app doesn't leak API-specific details.
- **API Clients**: Low-level networking logic.

#### 3. Presentation Layer (UI & State)
Handles the user interface and reactive state management.
- **Widgets/Screens**: Flutter UI components built with Material 3.
- **ViewModels**: Manage screen state and handle user interactions by invoking Use Cases.
- **Common Widgets**: Reusable UI components shared across features.

#### 4. Core Layer (Shared)
Cross-cutting concerns and infrastructure code.
- **DI (GetIt)**: Centralized Dependency Injection.
- **Theme**: Premium Material 3 design system with customized tokens.
- **Utils**: Generic utilities like the `Result` sealed class for error handling.

---

## Design Pattern Identification

The following patterns are consistently applied across the codebase:

### 1. Repository Pattern
Abstracts the data source (API, Database, Mock) from the business logic. This allows the app to switch between `MockAuthRepository` and `ApiAuthRepository` without touching the ViewModels.

### 2. Strategy Pattern
Used in conjunction with Dependency Injection to swap implementations at runtime. For example, based on `AppConfig.useMockData`, the DI container registers either a mock or a real API implementation.

### 3. Service Locator (Dependency Injection)
Managed by `package:get_it`. It provides a centralized way to resolve dependencies (`locator<LoginUseCase>()`), promoting decoupling and easier testing.

### 4. Observer Pattern
Implemented via Flutter's `ChangeNotifier` and `ValueListenableBuilder`. ViewModels notify the UI of state changes, triggering efficient rebuilds.

### 5. Command / Use Case Pattern
Encapsulates a single business action into a dedicated class. This makes the code self-documenting and extremely easy to test in isolation.

### 6. Result Pattern (Sealed Classes)
All asynchronous operations return a `Result<T>` object (either `Success` or `Failure`). This forces the caller to handle error cases explicitly, reducing runtime crashes.

### 7. Adapter / Mapper Pattern
Explicit mappers in `lib/data/mappers/` transform raw API data into clean domain entities, isolating the app from backend schema changes.

---

## Folder Structure

```text
lib/
├── core/                # Shared utilities, constants, and DI
│   ├── config/          # Centralized configuration (AppConfig)
│   ├── di/              # Dependency Injection setup (GetIt)
│   ├── theme/           # Material 3 Theme (BourgoTheme)
│   └── utils/           # Result class, formatting, etc.
├── data/                # Data retrieval and implementation
│   ├── api/             # API client & Mock Server
│   ├── mappers/         # DTO-to-Entity converters
│   ├── models/          # @JsonSerializable DTOs
│   └── repositories/    # Concrete repository implementations
├── domain/              # Pure business logic and interfaces
│   ├── entities/        # Pure business objects
│   ├── repositories/    # Abstract interfaces
│   └── usecases/        # Single-responsibility logic
├── presentation/        # UI layer organized by feature
│   ├── auth/            # Login, Register, Forgot Password
│   ├── onboarding/      # Welcome, Language Selection
│   ├── profile/         # Profile, Family Management, History
│   ├── home/            # Dashboard, Today's schedule
│   └── common/          # Reusable UI components (BrandLogo, Buttons)
├── l10n/                # Localization (ARB files)
├── main.dart            # Entry point
└── router.dart          # GoRouter configuration
```

---

## Theming & Branding Contract

### Premium Design System
- **Colors**: Strictly uses `Theme.of(context).colorScheme` with `ColorScheme.fromSeed`.
- **Typography**: Uses `google_fonts` (Inter/Outfit) exclusively.
- **Branding**: The `BrandLogo` widget handles both vertical and horizontal brandmarks with specific sizing constraints (e.g., 32dp for AppBars, 120dp for Auth headers).

### Localization
Real-time localization is implemented via `SettingsViewModel`. The app reacts instantly to locale changes without requiring a full restart or complex state lifting.

---

## Data Flow

1. **User action** in a Screen.
2. **ViewModel method** is called.
3. **Use Case** is invoked by the ViewModel.
4. **Repository** provides data (mapped from DTO to Entity).
5. **Result** is returned to the ViewModel.
6. **UI update** triggered via `notifyListeners()`.

---

For architectural rationale and decisions, see [DECISIONS.md](DECISIONS.md).
