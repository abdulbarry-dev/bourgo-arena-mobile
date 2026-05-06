# Project Architecture & Structure

## Overview
**Bourgo Arena Mobile** is a premium Flutter application designed for sports arena management, booking, and user engagement. The project provides a seamless experience for users to browse activities, manage reservations, and track their subscriptions. It is built with scalability and maintainability in mind, utilizing a clean, layered architecture that separates business logic from data sources and UI.

---

## High-Level Architecture
The application follows a **Layered MVVM (Model-View-ViewModel)** architecture, drawing inspiration from **Clean Architecture** principles. This ensures that the codebase is decoupled, testable, and adaptable to changes (e.g., switching from mock data to a live API).

### The Four Layers:
1.  **Presentation Layer**: Responsible for the UI and user interactions. It consists of Widgets (Views) and ViewModels (State Management).
2.  **Domain Layer**: The core of the application. It contains pure business logic, entities, and repository interfaces. It has zero dependencies on other layers.
3.  **Data Layer**: Responsible for data retrieval and persistence. It implements repository interfaces and interacts with external sources (REST API, Mock Server, Local Storage).
4.  **Core Layer**: Contains shared utilities, constants, themes, and the Dependency Injection (DI) system.

---

## Folder Structure

```text
lib/
├── core/                # Shared utilities, constants, and DI
│   ├── config/          # Centralized configuration (AppConfig)
│   ├── constants/       # App-wide constants (AppConstants)
│   ├── di/              # Dependency Injection setup (GetIt)
│   ├── theme/           # Material 3 Theme configuration (BourgoTheme)
│   └── utils/           # Shared utility classes (Result, etc.)
├── data/                # Data retrieval and implementation
│   ├── api/             # API client and Mock Server configuration
│   ├── mappers/         # Explicit DTO-to-entity converters
│   ├── models/          # DTOs (Data Transfer Objects)
│   ├── repositories/    # Concrete implementations of domain repositories
│   └── services/        # State-management services (AuthService, etc.)
├── domain/              # Pure business logic and interfaces
│   ├── entities/        # Plain Dart objects representing business data
│   ├── repositories/    # Abstract repository interfaces
│   └── usecases/        # Single-responsibility business logic classes
├── presentation/        # UI layer organized by feature
│   ├── <feature>/       # Feature directory
│   │   ├── viewmodels/  # Explicit ViewModel subfolder
│   │   └── <screen>.dart
│   └── common/          # Reusable UI components
├── l10n/                # Localization (i18n) files
├── main.dart            # Application entry point
└── router.dart          # GoRouter configuration
```

---

## Core Modules & Responsibilities

### Domain Entities
Located in `lib/domain/entities/`, these are pure Dart classes (e.g., `User`, `Activity`, `Reservation`). They represent the data the application works with and are independent of any database or API structure.

### Use Cases
Located in `lib/domain/usecases/`, these classes encapsulate a single business operation (e.g., `LoginUseCase`). They coordinate between repositories and return results wrapped in a `Result` object.

### Repositories
Repositories act as a bridge between the Domain and Data layers. 
- **Interfaces** (`lib/domain/repositories/`): Define what data operations are possible.
- **Implementations** (`lib/data/repositories/`): Define how those operations are performed.

---

## Data Flow & Communication

1.  **UI to ViewModel**: A Widget in the Presentation layer detects a user action and calls a method on its corresponding ViewModel.
2.  **ViewModel to Use Case**: The ViewModel invokes a Use Case to perform business logic.
3.  **Use Case to Repository**: The Use Case coordinates with Repositories to fetch or persist data.
4.  **Repository to Data Source**: The Repository implementation fetches data from the `ApiClient` or `MockServer`.
5.  **Reactive Update**: Data is mapped to entities via `Mappers`. ViewModels react to these changes and the UI rebuilds.

---

## Architectural Patterns & Principles

-   **Clean Architecture**: Separation of concerns into independent layers (Domain, Data, Presentation).
-   **MVVM**: Separation of UI (View) from logic (ViewModel).
-   **Dependency Injection**: Managed by `GetIt` for flexible dependency resolution.
-   **Service Locator**: Centralized locator for accessing singletons and factories.
-   **Single Responsibility Principle**: Each class (Use Case, Repository, ViewModel) has one clear job.

For detailed rationale behind these architectural choices, see [DECISIONS.md](DECISIONS.md).

---

## Setup & Configuration

### Environment Variables
The app uses `AppConfig` to manage environment-specific settings. You can override values using `--dart-define`:
```bash
flutter run --dart-define=BASE_URL=https://api.example.com --dart-define=USE_MOCK_DATA=false
```

### Code Generation
For JSON serialization, the project uses `json_serializable`. Run the following command after modifying models:
```bash
dart run build_runner build --delete-conflicting-outputs
```
