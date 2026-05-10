# Application Packages Documentation

This document provides a comprehensive overview of the third-party packages used in the Bourgo Arena mobile application, organized by their respective architectural layers and use cases.

---

## 1. Core & Architecture Layer
Packages that define the application's foundation, navigation, and dependency management.

| Package | Version | Why it was chosen | Use Case |
| :--- | :--- | :--- | :--- |
| `go_router` | `^17.2.2` | The official Flutter solution for declarative routing. | Handles all app navigation, deep linking, and authentication-based redirects. |
| `get_it` | `^9.2.1` | A simple, fast Service Locator for Dependency Injection (DI). | Decouples interface from implementation across Data, Domain, and Presentation layers. |
| `shared_preferences` | `^2.5.5` | Industry standard for simple key-value persistence. | Stores local settings, user preferences, and session tokens. |
| `http` | `^1.6.0` | Standard, reliable HTTP client for API communication. | Powers the `ApiClient` to interact with the Bourgo Arena REST API. |

---

## 2. Data & Serialization Layer
Packages used for data modeling, parsing, and collection management.

| Package | Version | Why it was chosen | Use Case |
| :--- | :--- | :--- | :--- |
| `json_annotation` | `^4.11.0` | Provides the annotations for code generation. | Marks model classes for automated JSON serialization. |
| `json_serializable` | `^6.13.1` | (Dev) Automates the creation of `fromJson` and `toJson` methods. | Ensures type-safe and consistent data mapping from API responses to DTOs. |
| `build_runner` | `^2.14.0` | Standard tool for running code generation in Dart. | Generates the `.g.dart` files for serialization and other boilerplate. |
| `collection` | `^1.19.1` | Provides advanced collection utilities. | Used for complex list manipulations and equality checks in domain entities. |

---

## 3. UI & Presentation Layer
Packages that enhance the visual identity, typography, and internationalization of the app.

| Package | Version | Why it was chosen | Use Case |
| :--- | :--- | :--- | :--- |
| `google_fonts` | `^8.0.2` | Allows easy integration of a wide range of modern fonts. | Implements the brand's typography (Inter, Outfit, etc.) without manual font bundling. |
| `material_symbols_icons` | `^4.2928.1` | Offers a more premium and modern set of icons than standard Material Icons. | Provides high-quality iconography across the entire application UI. |
| `intl` | `^0.20.2` | The standard Dart package for localization and formatting. | Handles date, number, and currency formatting throughout the app. |
| `flutter_localizations` | `SDK` | Built-in support for multi-language UI. | Enables the app to support French and Arabic locales. |
| `cupertino_icons` | `^1.0.8` | Default assets for iOS-style design elements. | Used for platform-specific UI components and standard iOS icons. |

---

## 4. Testing & Quality Assurance Layer
Packages dedicated to ensuring the reliability and correctness of the codebase.

| Package | Version | Why it was chosen | Use Case |
| :--- | :--- | :--- | :--- |
| `mocktail` | `^1.0.5` | A null-safe mocking library inspired by Mockito but with a cleaner API. | Used to create fakes and mocks for repositories and services in unit/widget tests. |
| `checks` | `^0.3.1` | (Dev) A modern assertion library with highly descriptive failure messages. | Replaces the standard `expect` for more readable and expressive test assertions. |
| `network_image_mock` | `^2.1.1` | (Dev) Simplifies testing of widgets that load images from the network. | Prevents 404/network errors when rendering `Image.network` in widget tests. |
| `flutter_test` | `SDK` | The official Flutter testing framework. | Core foundation for all widget and integration tests. |
| `test` | `^1.26.3` | (Dev) The underlying Dart test runner. | Provides the runner for pure Dart unit tests. |

---

## 5. Development Utilities
Tools used during the development lifecycle but not bundled with the production app.

| Package | Version | Why it was chosen | Use Case |
| :--- | :--- | :--- | :--- |
| `flutter_launcher_icons` | `^0.14.4` | (Dev) Simplifies the complex process of generating platform-native icons. | Automatically generates all required Android and iOS launcher icons from a single source. |
| `flutter_lints` | `^6.0.0` | (Dev) Recommended lint rules for Flutter development. | Enforces code quality and consistency as defined in `analysis_options.yaml`. |

---

## Summary Table

| Category | Count | Key Technologies |
| :--- | :--- | :--- |
| **Architecture** | 4 | `go_router`, `get_it` |
| **Data** | 4 | `json_serializable`, `http` |
| **UI** | 5 | `google_fonts`, `material_symbols_icons` |
| **Testing** | 5 | `mocktail`, `checks` |
| **Dev Utils** | 2 | `flutter_launcher_icons` |
