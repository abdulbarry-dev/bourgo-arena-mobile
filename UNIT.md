UNIT Tests — Project Test Layer
================================

Purpose
-------
This document records the project's current unit and widget testing conventions, what has been implemented, and how to run tests locally. It is a living document and reflects the current state of the test layer as of the latest commits.

Summary of Recent Changes
-------------------------
- Repository tests: Completed.
  - Files added under `test/unit/data/repositories/`:
    - `api_activity_repository_test.dart`
    - `api_course_repository_test.dart`
    - `api_notification_repository_test.dart`
    - `api_reservation_repository_test.dart`
    - `api_user_repository_test.dart`
  - Existing repository test files were adjusted for resilient assertions and correct imports:
    - `api_auth_repository_test.dart` (improved auth-state stream matcher)
    - `local_session_repository_test.dart` (added missing `Result` import)
  - All repository tests pass locally: `flutter test test/unit/data/repositories`.

- ViewModel tests: Started.
  - `LoginViewModel` unit tests added (pure-Dart + flutter_test harness where needed):
    - `test/unit/presentation/viewmodels/login_view_model_test.dart`
  - Tests cover: invalid form handling (no call), successful login flow (use case invoked, loading state), and failure path (SnackBar shows failure message).

- Widget tests: Scaffolded and prepared for the login screen.
  - `test/widget/auth/login_screen_test.dart` created as a scaffold to exercise UI interactions and SnackBar assertions.
  - Next steps: implement end-to-end widget interactions using mocked ViewModels and the DI `locator` reset pattern where necessary.

Conventions & Guidelines
------------------------
- Unit tests (domain + data layers): use `package:test` and `mocktail` for mocking. Keep them pure Dart when possible (no Flutter bindings).
- ViewModel tests: use `flutter_test` (widget binding) but avoid pumping full widgets when the logic is pure; mock UseCases with `mocktail`.
- Widget tests: use `flutter_test` + real `WidgetTester`. Inject mocked dependencies via `locator.reset()` and `locator.registerFactory()` when the screen uses global DI.
- Test fixtures: reusable helpers live in `test/unit/data/repositories/repository_test_fixtures.dart`.

How to run tests
----------------
- Run repository tests:

```bash
flutter test test/unit/data/repositories
```

- Run ViewModel tests:

```bash
flutter test test/unit/presentation/viewmodels
```

- Run widget tests (login scaffold):

```bash
flutter test test/widget/auth/login_screen_test.dart
```

- Run full test suite with coverage:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

Next Actions
------------
1. Complete ViewModel tests across other ViewModels (start with `RegisterViewModel`, `ProfileViewModel`, `BookingViewModel`).
2. Implement widget tests for key screens (Login, Booking flow, Profile), mocking ViewModels and stabilizing navigation.
3. Run coverage and produce a gap analysis to prioritize missing tests.

Notes
-----
- Keep domain entities Flutter-free (no `IconData`, `ThemeMode` etc.) in pure-Dart unit tests.
- Reuse `repository_test_fixtures.dart` for consistent test data across repository tests.

If anything above is out-of-date or you'd like a different format (JSON checklist, or a shorter README-style entry), tell me and I'll update it.
