---
trigger: always_on
---

# Flutter AI Rules — Summary

---

## Interaction Guidelines
- Assume users know programming but may be new to Dart; explain null safety, futures, and streams.
- Ask for clarification on ambiguous requests (functionality + target platform).
- Explain benefits when suggesting pub.dev packages.
- Use `dart_format`, `dart_fix`, and `analyze_files` tools for formatting, fixes, and linting.

---

## Project Structure
Standard Flutter layout with `lib/main.dart` as the entry point.

---

## Flutter Style Guide
- Apply **SOLID principles** throughout.
- Write concise, declarative Dart; prefer functional patterns.
- Favor **composition over inheritance**.
- Prefer **immutable data structures** and `StatelessWidget`.
- Separate ephemeral state from app state; use a state management solution for app state.
- Use `go_router` for navigation and routing.

---

## Package Management
- Use the `pub` tool to add/remove packages.
  - Regular: `flutter pub add <package>`
  - Dev: `flutter pub add dev:<package>`
  - Override: `flutter pub add override:<package>:1.0.0`
  - Remove: `dart pub remove <package>`
- Use `pub_dev_search` if available when evaluating new packages.

---

## Code Quality
- Separate UI logic from business logic.
- Use meaningful, descriptive names — no abbreviations.
- Lines ≤ 80 characters; `PascalCase` for classes, `camelCase` for members, `snake_case` for files.
- Keep functions short (< 20 lines) with a single purpose.
- Handle errors explicitly — never fail silently.
- Use `dart:developer` `log()` instead of `print()`.

---

## Dart Best Practices
- Follow **Effective Dart** guidelines.
- Use `async`/`await` for async ops; `Stream`s for sequences of async events.
- Write soundly **null-safe** code; avoid `!` unless value is guaranteed non-null.
- Use **pattern matching**, **records**, and exhaustive **switch expressions**.
- Use `try-catch` with appropriate exception types; define custom exceptions where needed.
- Use arrow syntax for simple one-line functions.
- Add `///` doc comments to all public APIs.

---

## Flutter Best Practices
- Use small, **private Widget classes** instead of helper methods returning `Widget`.
- Break large `build()` methods into smaller reusable widgets.
- Use `ListView.builder` / `SliverList` for long lists (lazy loading).
- Use `compute()` for expensive calculations to avoid blocking the UI thread.
- Use **`const` constructors** wherever possible to reduce rebuilds.
- Never perform network calls or heavy computation inside `build()`.

---

## Application Architecture
Organize into logical layers:
- **Presentation** — widgets, screens
- **Domain** — business logic
- **Data** — model classes, API clients
- **Core** — shared utilities, extensions

For large projects, organize by **feature**, each with its own presentation/domain/data subfolders. Use **MVVM** when a robust solution is needed.

---

## State Management
| Scenario | Solution |
|---|---|
| Single value, local | `ValueNotifier` + `ValueListenableBuilder` |
| Complex/shared state | `ChangeNotifier` + `ListenableBuilder` |
| Single async op | `Future` + `FutureBuilder` |
| Async event sequence | `Stream` + `StreamBuilder` |
| DI beyond manual injection | `provider` (only if explicitly requested) |

Use **manual constructor dependency injection** by default to keep dependencies explicit and testable.

---

## Routing with GoRouter
```dart
// 1. Add: flutter pub add go_router
// 2. Configure
final GoRouter _router = GoRouter(
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
);
// 3. Use in MaterialApp.router(routerConfig: _router)
```
Use `go_router`'s `redirect` for auth flows. Use `Navigator` only for non-deep-linkable transient screens (dialogs, etc.).

---

## Data Handling & Serialization
- Use `json_serializable` + `json_annotation` for JSON parsing.
- Use `fieldRename: FieldRename.snake` to map camelCase → snake_case JSON.
- Abstract data sources via **Repositories/Services** for testability.
- Run code generation with:
  ```shell
  dart run build_runner build --delete-conflicting-outputs
  ```

---

## Testing
| Type | Package |
|---|---|
| Unit | `package:test` |
| Widget | `package:flutter_test` |
| Integration | `package:integration_test` |
| Assertions | `package:checks` (preferred) |
| Mocks | Fakes/stubs preferred; `mockito`/`mocktail` if needed |

- Follow **Arrange-Act-Assert** (Given-When-Then).
- Write unit tests for domain logic, widget tests for UI, integration tests for end-to-end flows.
- Aim for **high test coverage**.

---

## Visual Design & Theming

### ThemeData
- Generate color palettes with `ColorScheme.fromSeed()`.
- Always provide both `theme` (light) and `darkTheme` (dark) to `MaterialApp`.
- Customize components via `appBarTheme`, `elevatedButtonTheme`, etc.
- Control theme switching with `themeMode` (`ThemeMode.light/dark/system`).

### Custom Design Tokens
Use `ThemeExtension<T>` for custom styles beyond standard `ThemeData`. Implement `copyWith` and `lerp`. Register in `ThemeData.extensions`. Access via `Theme.of(context).extension<MyColors>()!`.

### WidgetStateProperty
```dart
backgroundColor: WidgetStateProperty.resolveWith<Color>(
  (states) => states.contains(WidgetState.pressed) ? Colors.green : Colors.red,
),
```

### Custom Fonts
Use `google_fonts` package. Define a `TextTheme` and apply consistently.

---

## Layout Best Practices
- **Row/Column overflow:** use `Expanded`, `Flexible`, or `Wrap`.
- **Scrollable fixed content:** `SingleChildScrollView`.
- **Long lists/grids:** always use `.builder` constructors.
- **Scaling:** `FittedBox`; **responsive:** `LayoutBuilder` or `MediaQuery`.
- **Layering:** `Stack` + `Positioned` / `Align`.
- **Overlays (dropdowns, tooltips):** use `OverlayPortal`.

---

## Color & Typography Guidelines

### Color
- Follow **WCAG 2.1**: ≥ 4.5:1 contrast for normal text, ≥ 3:1 for large text.
- Use the **60-30-10 rule**: 60% primary/neutral, 30% secondary, 10% accent.
- Use complementary colors sparingly (accents only, not text/background pairs).

### Typography
- Limit to **1–2 font families**.
- Establish a **typographic scale** (display → title → body → label).
- Line height: **1.4×–1.6×** font size; line length: **45–75 characters**.
- Avoid all-caps for long-form text.

---

## Lint Configuration (`analysis_options.yaml`)
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # avoid_print: false
    # prefer_single_quotes: true
```

---

## Accessibility
- Contrast ratio ≥ **4.5:1** for all text.
- Support **dynamic text scaling** — test at large font sizes.
- Use `Semantics` widget for descriptive labels.
- Test with **TalkBack** (Android) and **VoiceOver** (iOS).

---

## Documentation Style
- Use `///` for all public API doc comments.
- First line: a single concise summary sentence ending with a period.
- Explain *why*, not *what* — code should be self-explanatory.
- Include code samples, parameter/return/exception descriptions where useful.
- Place doc comments **before** any annotations.
- No useless documentation that just restates the obvious.