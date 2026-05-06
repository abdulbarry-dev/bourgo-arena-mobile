# Architectural Decisions

This document records the rationale behind the structural and architectural choices made for the Bourgo Arena Mobile project.

## 1. Clean Architecture (Use Case Layer)
**Decision**: Introduced a dedicated `domain/usecases/` layer.
**Rationale**: 
- **Separation of Concerns**: Moves business logic out of Services (which now focus on state management) into single-purpose classes.
- **Testability**: Use cases can be tested in isolation with mocked repositories.
- **Standardization**: Uses the `Result` utility for explicit success/failure handling.

## 2. Layered MVVM with Explicit Boundaries
**Decision**: Moved ViewModels into `viewmodels/` subfolders within features.
**Rationale**: 
- **Discoverability**: Clearly separates UI code (Screens/Widgets) from state logic.
- **Consistency**: Follows a predictable pattern across all features.

## 3. Service Location (GetIt)
**Decision**: Replaced manual DI with the `get_it` package.
**Rationale**: 
- **Efficiency**: Supports lazy singletons, reducing startup time.
- **Flexibility**: Easier to switch between Mock and API implementations without modifying widget trees.
- **Scalability**: Decouples dependency resolution from the `MaterialApp` structure.

## 4. Explicit Data Mappers
**Decision**: Created `data/mappers/` for DTO-to-entity conversion.
**Rationale**: 
- **Isolation**: Prevents Data layer models (DTOs) with JSON logic from leaking into the Domain layer.
- **Safety**: Ensures the Domain layer works with pure, stable entities.

## 5. Centralized Configuration (AppConfig)
**Decision**: Implemented `AppConfig` with `--dart-define` support.
**Rationale**: 
- **Environment Management**: Single source of truth for Base URLs, Mocking flags, and Timeouts.
- **Security**: Allows sensitive config to be injected at build time rather than hardcoded.

## 6. Core Organization
**Decision**: Reorganized `lib/core` into subfolders.
**Rationale**: 
- **Scalability**: Prevents the core directory from becoming a "dumping ground" for miscellaneous files.
- **Structure**: Groups utilities, themes, and DI logic logically.
