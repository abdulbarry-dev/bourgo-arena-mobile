# Testing Documentation — Bourgo Arena Mobile

This document outlines the testing architecture, strategies, and best practices implemented in the Bourgo Arena mobile application. Our goal is to maintain a robust, reliable codebase through comprehensive automated testing across all layers.

---

## 1. Testing Architecture Overview

The project follows a layered testing approach that mirrors our **Clean MVVM Architecture**. Tests are organized in the `test/` directory, paralleling the `lib/` structure to ensure discoverability and consistency.

### Folder Structure

```
test/
  unit/                  # Logic and State tests
    core/                # Utilities and extensions
    data/                # Repositories and API clients
    domain/              # Use cases and business logic
    presentation/        # ViewModels and controllers
  widget/                 # Component and interaction tests
  integration_test/      # [Future] End-to-end user flows
  test_utils.dart        # Shared test factories (createTestUser)
```

### Relationship Between Test Types

- **Unit Tests**: Focus on individual classes and functions (UseCases, Repositories, ViewModels). We aim for isolated tests using mocks for dependencies.
- **Widget Tests**: Verify the rendering and interaction of UI components. These tests ensure that the UI reacts correctly to state changes and user inputs.
- **Integration Tests**: (Planned) Validate complete features or workflows by running on real devices, involving the entire app stack. These live in the `integration_test/` directory.

---

## 2. Testing Stack

We use a modern, powerful set of tools to ensure test quality and readability:

| Tool | Purpose |
|---|---|
| `flutter_test` | Core testing framework and widget testing environment. |
| `mocktail` | Null-safe mocking library for stubbing and verifying dependencies. |
| `package:checks` | Advanced, type-safe assertion library for more readable expectations. |
| `build_runner` | Used to generate JSON serialization code and mocks (when needed). |

---

## 3. Layered Testing Strategy

### Data Layer

- **API Clients**: Tested using `MockHttpClient` to verify header injection, URL construction, and response status code handling (mapping HTTP errors to domain exceptions).
- **Repositories**: Verified by stubbing `ApiClient` responses. We test the mapping from JSON DTOs to Domain Entities and ensure the `Result<T, Failure>` pattern is correctly implemented.
- **Models**: Unit tests ensure that `@JsonSerializable` classes correctly handle serialization/deserialization, especially for complex nested objects.

### Domain Layer

- **Use Cases**: Pure logic tests. We mock the Repositories to verify that Use Cases correctly orchestrate data flow and handle failures without leaking implementation details.
- **Entities**: Tested for value equality and business-specific helper methods.

### Presentation Layer

- **ViewModels**: Tested for state transitions (e.g., `isLoading`), error message propagation, and interaction with Use Cases.
- **Widgets**: Focus on initial rendering, presence of key widgets (buttons, fields), and triggering navigation or side effects (SnackBars) on user interaction.

---

## 4. Testing Patterns & Conventions

### Assertions with `package:checks`

We prefer `check()` over `expect()` for improved readability and better error messages.

```dart
// Preferred
check(viewModel.isLoading).isTrue();
check(result).isA<Success<User, Failure>>();

// Deprecated (legacy)
expect(viewModel.isLoading, isTrue);
```

### Mocking Dependencies

Use `mocktail` for all dependency injection in tests. Define mocks at the top of the test file:

```dart
class MockAuthRepository extends Mock implements AuthRepository {}
```

### Test Fixtures

To avoid boilerplate, we use factory functions for both Entities and JSON DTOs.

- **Shared Entities**: Found in [test_utils.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/test/test_utils.dart).
- **Domain/Data Fixtures**: Found in [repository_test_fixtures.dart](file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/test/unit/data/repositories/repository_test_fixtures.dart).

```dart
// Example using a fixture
final user = testUserEntity(id: '123', email: 'test@example.com');
final json = testUserJson(id: '123');
```

### Mocking and Fallback Values

When using `mocktail` with custom types in `any()` or `captureAny()`, you must register fallback values in `setUpAll`:

```dart
setUpAll(() {
  registerFallbackValue(testUserEntity());
  registerFallbackValue(MockBuildContext());
});
```

### Result Pattern Handling

Since we use the `Result<T, Failure>` pattern, tests must verify both success and failure branches:

```dart
test('returns AuthFailure on invalid credentials', () async {
  when(() => repository.login(any(), any()))
      .thenAnswer((_) async => FailureResult(AuthFailure('Invalid')));
  
  final result = await useCase('user', 'pass');
  check(result).isA<FailureResult>();
});
```

---

## 5. Workflow & Maintenance

### Running Tests

- **All tests**: `flutter test`
- **Specific directory**: `flutter test test/unit/data`
- **With coverage**: `flutter test --coverage`

### Coverage Strategy
We prioritize coverage in the following order:
1. **Domain Layer (100%)**: Critical business rules and entities.
2. **Data Layer (>90%)**: Critical for data integrity and error mapping.
3. **ViewModels (>80%)**: Crucial for UI state consistency.
4. **Widgets**: Focus on complex interactions and branching paths.

### Generating HTML Reports
For a visual representation of coverage, use the following commands:
```bash
# 1. Run tests with coverage
flutter test --coverage

# 2. Generate HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html

# 3. Open in browser
open coverage/html/index.html
```

### Continuous Integration
Tests are automatically run on every Pull Request. A failure in the testing suite blocks the merge. We also enforce `dart analyze` and `dart format` checks to maintain code quality.

---

## 6. Best Practices

- **Zero Force-Unwraps**: Avoid `!` in tests unless absolutely necessary and documented.
- **Const Constructors**: Always use `const` for widgets and entities in tests to mirror production performance.
- **Small Widgets**: Test complex screens by breaking them into smaller, testable private widget classes.
- **Clean Slate**: Use `setUp` to reset state between tests and `tearDown` to clear listeners or timers.
- **Readable Names**: Use descriptive test descriptions: `group('LoginViewModel - validation', () { ... });`.
- **Prefer Fakes over Mocks**: For complex dependencies like a local database or session storage, consider using a `Fake` implementation if the mock logic becomes too brittle.
- **Verify No Side Effects**: When testing failures, always verify that the state hasn't changed unexpectedly (e.g., `verifyNever(...)`).
