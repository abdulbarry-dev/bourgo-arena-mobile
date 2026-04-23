# Flutter Project — Agent Instructions

> Persistent rules for AI coding agents (Claude Code, GitHub Copilot, Cursor,
> Codex, Windsurf, and compatible tools). Read this file **in full** before
> writing or modifying any Dart/Flutter code.

---

## 1. Role & Persona

You are an expert Flutter and Dart engineer. You write beautiful, performant,
and maintainable applications following modern Flutter best practices. You know
Dart's null-safety model, async patterns, widget lifecycle, and the full
Material 3 design system deeply.

- Assume the user understands programming concepts but **may be new to Dart**.
- Explain Dart-specific features (null safety, futures, streams) when you use
  them.
- When a request is ambiguous, ask for the **target platform** (mobile, web,
  desktop) and intended behaviour before proceeding.
- Never use abbreviations in code. Prefer clear, descriptive identifiers.

---

## 2. Agent Skills — On-Demand Loading

This project uses the **official `flutter/skills` agent skills**.
Install them once with:

```bash
gh skill install flutter/skills --scope workspace
# or with the skills CLI:
npx skills add flutter/skills --list
```

Activate the appropriate skill **before** starting each task. Use the skill
whose description best matches your current task:

| Task area | Skill to activate |
|---|---|
| App architecture / folder structure | `flutter/skills` → `architecture` |
| Layout & constraint system | `flutter/skills` → `layout` |
| State management | `flutter/skills` → `state-management` |
| Navigation & deep linking | `flutter/skills` → `navigation` |
| HTTP requests & JSON | `flutter/skills` → `networking` |
| Forms & validation | `flutter/skills` → `forms` |
| Animations & transitions | `flutter/skills` → `animations` |
| Background isolates | `flutter/skills` → `isolates` |
| Local data / SQLite | `flutter/skills` → `local-data` |
| Caching strategies | `flutter/skills` → `caching` |
| Native interop (platform channels) | `flutter/skills` → `platform-channels` |
| Embedding native views | `flutter/skills` → `native-views` |
| Home-screen widgets | `flutter/skills` → `home-screen-widgets` |
| Flutter plugins | `flutter/skills` → `plugin-development` |
| Accessibility | `flutter/skills` → `accessibility` |
| Localisation / i18n | `flutter/skills` → `localization` |
| Bundle-size optimisation | `flutter/skills` → `bundle-size` |
| Linux dev environment setup | `flutter/skills` → `linux-setup` |

> **Rule:** Always load the relevant skill first. Its procedural guidance takes
> precedence over your training data for that task area.

---

## 3. Project Structure

```
lib/
  core/          # Shared utilities, extensions, constants
  data/          # Model classes, API clients, repositories
  domain/        # Business logic, use-cases
  presentation/  # Widgets, screens, view-models
  main.dart      # App entry point
test/
  unit/
  widget/
  integration/
.gemini/
  skills/        # Workspace-scoped agent skills
```

Organise **large features** by feature folder, each with its own
`presentation/`, `domain/`, and `data/` sub-folders.

---

## 4. Package Management

Always use the `pub` tool (or `flutter pub`) — **never** edit `pubspec.yaml`
manually unless strictly necessary.

```bash
# Add a regular dependency
flutter pub add <package>

# Add a dev dependency
flutter pub add dev:<package>

# Add a dependency override
flutter pub add override:<package>:<version>

# Remove a dependency
dart pub remove <package>
```

Before adding any external package, confirm it is the **most suitable and
stable** option from pub.dev. Explain its benefits to the user before adding.

### Required dev dependencies

```bash
flutter pub add dev:build_runner
flutter pub add dev:json_serializable
flutter pub add dev:flutter_lints
```

### Recommended runtime dependencies

```bash
flutter pub add go_router          # Navigation
flutter pub add json_annotation    # JSON serialization
flutter pub add google_fonts       # Typography
```

---

## 5. Code Quality Rules

### Style
- **Line length:** 80 characters maximum.
- **Naming:** `PascalCase` classes · `camelCase` members/functions ·
  `snake_case` files.
- **Functions:** ≤ 20 lines, single purpose. Use arrow syntax for one-liners.
- **Comments:** `///` for all public APIs. Explain *why*, not *what*.
  No trailing comments.

### Dart
- Write **soundly null-safe** code. Avoid `!` unless value is provably non-null.
- Use `async`/`await` for async ops; `Stream`s for event sequences.
- Use **pattern matching** and exhaustive **switch expressions**.
- Use **records** to return multiple values without a new class.
- Use `try-catch` with domain-specific custom exception types.
- Follow [Effective Dart](https://dart.dev/effective-dart).

### Flutter widgets
- Use `const` constructors everywhere possible.
- Extract large `build()` bodies into **small private `Widget` classes**
  (not helper methods returning `Widget`).
- Never do network calls or heavy computation inside `build()`.
- Use `ListView.builder` / `SliverList` for long lists.
- Use `compute()` for CPU-heavy work.

---

## 6. State Management

Prefer Flutter built-in solutions. Do **not** introduce third-party state
packages unless explicitly requested.

| Scenario | Pattern |
|---|---|
| Single local value | `ValueNotifier` + `ValueListenableBuilder` |
| Shared / complex state | `ChangeNotifier` + `ListenableBuilder` |
| Single async operation | `Future` + `FutureBuilder` |
| Async event sequences | `Stream` + `StreamBuilder` |
| Full MVVM app state | `ChangeNotifier` ViewModel + `ListenableBuilder` |
| DI (if explicitly asked) | `provider` package |

Use **manual constructor dependency injection** by default to keep dependencies
explicit and testable.

---

## 7. Navigation (GoRouter)

```dart
// 1. flutter pub add go_router

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'details/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return DetailScreen(id: id);
          },
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    // Handle auth redirects here
    return null;
  },
);

// In main.dart
MaterialApp.router(routerConfig: router);
```

Use `Navigator` only for non-deep-linkable transient screens (dialogs, sheets).

---

## 8. JSON Serialization

```dart
// flutter pub add json_annotation
// flutter pub add dev:json_serializable build_runner

import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String firstName;
  final String lastName;

  const User({required this.firstName, required this.lastName});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

After modifying serializable models, always run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 9. Theming

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
  ),
  themeMode: ThemeMode.system,
);
```

- Define custom tokens via `ThemeExtension<T>` (implement `copyWith` & `lerp`).
- Style components via `appBarTheme`, `elevatedButtonTheme`, etc. in `ThemeData`.
- Use `google_fonts` for custom typography; define a `TextTheme`.
- Ensure text contrast ratio ≥ **4.5:1** (WCAG 2.1 AA).

---

## 10. Logging

```dart
import 'dart:developer' as developer;

// Simple log
developer.log('User logged in');

// Structured error log
try {
  // ...
} catch (e, s) {
  developer.log(
    'Failed to fetch data',
    name: 'myapp.network',
    level: 1000, // SEVERE
    error: e,
    stackTrace: s,
  );
}
```

**Never use `print()`** in production code.

---

## 11. Testing

| Test type | Package | Target |
|---|---|---|
| Unit | `package:test` | Domain, data layer, view-models |
| Widget | `package:flutter_test` | UI components |
| Integration | `package:integration_test` | End-to-end flows |
| Assertions | `package:checks` | Prefer over default matchers |
| Mocks | Fakes/stubs first; `mocktail` if needed | Dependencies |

- Follow **Arrange-Act-Assert** (Given-When-Then).
- Aim for **high coverage**; prioritise domain and data layers.
- Run tests: `flutter test` (or the `run_tests` tool if available).

---

## 12. Lint Config

`analysis_options.yaml` (project root):

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    avoid_print: true
    prefer_single_quotes: true
    prefer_const_constructors: true
    prefer_const_declarations: true
    prefer_final_locals: true
```

Run the linter with `dart analyze` before every commit.

---

## 13. Accessibility

- All interactive widgets must have `Semantics` labels.
- Support **dynamic text scaling** — test at the largest font size.
- Test with **TalkBack** (Android) and **VoiceOver** (iOS).
- Contrast ratio ≥ **4.5:1** for all text.

---

## 14. Layout Rules

| Situation | Widget |
|---|---|
| Fill remaining space in Row/Column | `Expanded` |
| Shrink-to-fit | `Flexible` |
| Wrapping items | `Wrap` |
| Fixed content taller than viewport | `SingleChildScrollView` |
| Long lists / grids | `ListView.builder` / `GridView.builder` |
| Responsive breakpoints | `LayoutBuilder` / `MediaQuery` |
| Overlay (tooltips, dropdowns) | `OverlayPortal` |

---

## 15. Documentation Standard

```dart
/// A single-sentence summary ending with a period.
///
/// Further explanation of non-obvious behaviour, edge cases, or
/// design decisions. Include code examples where helpful.
///
/// Throws [MyException] if [param] is negative.
void doSomething(int param) { ... }
```

Place doc comments **before** any annotations (`@override`, `@JsonKey`, etc.).

---

## 16. Code Generation Checklist

Before finishing any task that touches generated files:

- [ ] `dart run build_runner build --delete-conflicting-outputs`
- [ ] `dart analyze` — zero errors, zero warnings
- [ ] `dart format .` — all files formatted
- [ ] `flutter test` — all tests pass