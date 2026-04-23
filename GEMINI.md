# GEMINI.md — Flutter Project Configuration

> This file is loaded automatically by Gemini CLI at the start of every
> session. It defines the **persistent rules, architecture decisions, and
> agent behaviour** for this Flutter project. You must follow every section
> below for the entire session.

---

## Project Identity

- **Framework:** Flutter (Dart)
- **Target platforms:** Mobile (Android + iOS), Web, Desktop
- **Architecture:** Layered MVVM — Presentation / Domain / Data / Core
- **Navigation:** `go_router`
- **State management:** Flutter built-ins (`ChangeNotifier`, `ValueNotifier`,
  `Stream`) — no third-party state packages unless explicitly requested
- **Serialization:** `json_serializable` + `json_annotation`
- **Typography:** `google_fonts`
- **Routing:** `go_router` declarative routes with `redirect` for auth flows
- **Logging:** `dart:developer` — never `print()`

---

## Agent Skills

This project uses the **official `flutter/skills`** agent skill set.

### Auto-activate rules

Gemini must **automatically activate the correct skill** when it detects a
task that matches a skill's scope. Do not wait for the user to ask.

```
flutter/skills → architecture       when: designing folder structure or layers
flutter/skills → layout             when: building or fixing UI layouts
flutter/skills → state-management   when: managing widget or app state
flutter/skills → navigation         when: adding routes, deep links, or auth redirects
flutter/skills → networking         when: making HTTP calls or parsing JSON
flutter/skills → forms              when: building forms or input validation
flutter/skills → animations         when: adding transitions or motion
flutter/skills → isolates           when: running heavy computation off the UI thread
flutter/skills → local-data         when: storing structured data with SQLite
flutter/skills → caching            when: implementing offline support or data caching
flutter/skills → platform-channels  when: calling native Android/iOS/macOS APIs
flutter/skills → native-views       when: embedding maps, web views, or native components
flutter/skills → home-screen-widgets when: adding Android/iOS home-screen widgets
flutter/skills → plugin-development when: building a reusable Flutter plugin
flutter/skills → accessibility      when: configuring screen-reader support or semantics
flutter/skills → localization       when: adding i18n or multi-language support
flutter/skills → bundle-size        when: measuring or reducing APK/IPA size
flutter/skills → linux-setup        when: configuring a Linux Flutter dev environment
```

The skill's procedural guidance **overrides** your training data for that task.

### Installing skills (run once)

```bash
gh skill install flutter/skills --scope workspace
# or
npx skills add flutter/skills --global
```

---

## Core Mandates

Every response that produces Dart/Flutter code **must** comply with all of
the following. Non-compliance is a failure state.

### 1. Null Safety
- Write soundly null-safe code at all times.
- Never use `!` (force-unwrap) unless the value is **provably** non-null with
  a comment explaining why.
- Use `??`, `?.`, `if (x != null)` guards, and early returns instead.

### 2. Widget Hygiene
- Use `const` constructors on every widget and in every `build()` call where
  possible.
- Never return `Widget` from a private helper method. Always create a **small
  private `StatelessWidget` or `StatefulWidget` class** instead.
- Never perform network calls, database queries, or heavy computation inside
  `build()`.

### 3. State Management Rules
- **Default:** use `ValueNotifier` + `ValueListenableBuilder` for simple
  local state; `ChangeNotifier` + `ListenableBuilder` for complex/shared state.
- Use `Future`/`FutureBuilder` for single async ops.
- Use `Stream`/`StreamBuilder` for event sequences.
- Do **not** add third-party state packages (`riverpod`, `bloc`, `redux`, etc.)
  unless the user explicitly requests one by name.

### 4. Dependency Injection
- Default to **manual constructor injection**.
- If a DI framework is needed beyond that, use the `provider` package only if
  the user explicitly asks for it.

### 5. Navigation
- Always use `go_router` for declarative routing and deep linking.
- Configure auth redirects in the `redirect` callback — never in widget code.
- Use `Navigator.push` / `Navigator.pop` only for transient screens (dialogs,
  bottom sheets) that don't need deep links.

### 6. Code Style
- Lines ≤ **80 characters**.
- `PascalCase` for classes, `camelCase` for members/functions, `snake_case`
  for file names.
- Functions ≤ **20 lines**, single responsibility.
- Arrow syntax (`=>`) for single-expression functions.
- No abbreviations in identifiers.
- No trailing comments.
- No `print()` — use `dart:developer` `log()`.

### 7. Serialization
- Use `@JsonSerializable(fieldRename: FieldRename.snake)` for all model
  classes.
- After editing any serializable model, always run:

  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```

### 8. Testing
- Write or update **unit tests** for any domain or data layer change.
- Write or update **widget tests** for any widget change.
- Use `package:checks` for assertions.
- Prefer fakes/stubs over mocks; use `mocktail` only when stubs are
  insufficient.

### 9. Linting & Formatting
- After every code change run, in this exact order:

  ```bash
  dart format .
  dart analyze
  flutter test
  ```

- All three must pass with **zero errors** before the task is complete.

### 10. Documentation
- Add `///` doc comments to **all** public classes, constructors, methods, and
  top-level functions.
- First line: one-sentence summary ending with a period.
- Explain *why* in comments, not *what* — the code explains what.
- Place doc comments **before** any annotations.

---

## Architecture Reference

```
lib/
  core/
    extensions/          # Dart extension methods
    utils/               # Pure utility functions
    constants.dart       # App-wide constants
  data/
    models/              # @JsonSerializable DTOs
    repositories/        # Repository implementations
    services/            # API clients, database helpers
  domain/
    entities/            # Pure business objects
    repositories/        # Abstract repository interfaces
    use_cases/           # Single-purpose use-case classes
  presentation/
    <feature>/
      widgets/           # Feature-specific private widgets
      <feature>_screen.dart
      <feature>_view_model.dart
  main.dart
  router.dart            # GoRouter configuration
  theme.dart             # ThemeData (light + dark)

test/
  unit/
  widget/
  integration/

.gemini/
  skills/               # Workspace agent skills (flutter/skills)
```

---

## Theming Contract

The app uses **Material 3** with `ColorScheme.fromSeed`. Do not hardcode
colors in widgets — always use `Theme.of(context).colorScheme.*` or the
custom `ThemeExtension`.

```dart
// theme.dart (simplified reference)
final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF0D47A1),
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.interTextTheme(),
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF0D47A1),
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
);
```

Custom tokens live in `AppColors extends ThemeExtension<AppColors>`.
Access them via `Theme.of(context).extension<AppColors>()!`.

---

## Hooks

### BeforeTool — Security Guard

Before writing any file, Gemini must verify:

1. **No secrets hardcoded** — API keys, Firebase project IDs, tokens, and
   passwords must come from `.env` files or `--dart-define` flags. If found
   hardcoded, **block the write** and instruct the user to use env vars.
2. **No `print()` calls** — replace with `developer.log(...)`.
3. **No force-unwrap `!`** without a justification comment above the line.

If any check fails: **stop**, explain the violation, and suggest the correct
pattern before proceeding.

### AfterTool — Post-write Checklist

After every file write that touches `.dart` files, confirm (do not execute
automatically — prompt the user to run):

```bash
dart format <file>
dart analyze <file>
```

---

## Gemini Interaction Style

- When the user's request is ambiguous, ask for **one clarifying question**
  targeting the most important unknown (platform, feature scope, or data
  source) before writing code.
- After completing a task, provide a **brief summary** (≤ 5 bullet points) of
  what was changed and what the user should run next.
- Never produce clever or obscure code. Prefer readable over concise when they
  conflict.
- Always surface relevant `flutter/skills` skill activations at the start of
  the response so the user knows what specialist context is active.

---

## Quick Reference — Common Commands

```bash
# Add packages
flutter pub add go_router
flutter pub add json_annotation google_fonts
flutter pub add dev:json_serializable build_runner flutter_lints mocktail

# Code generation
dart run build_runner build --delete-conflicting-outputs

# Lint + format
dart format .
dart analyze

# Run tests
flutter test

# Run app (choose platform)
flutter run -d chrome          # Web
flutter run -d macos           # macOS desktop
flutter run                    # Connected mobile device

# Build
flutter build apk --release
flutter build ios --release
flutter build web --release
```

---

## Non-Negotiables (Never Do)

| ❌ Forbidden | ✅ Required instead |
|---|---|
| `print(...)` | `developer.log(...)` |
| Hardcoded colors | `Theme.of(context).colorScheme.*` |
| Helper methods returning `Widget` | Private `StatelessWidget` class |
| Network calls in `build()` | `FutureBuilder` / ViewModel |
| Manual `pubspec.yaml` edits | `flutter pub add` |
| Force-unwrap `!` without comment | Null-safe guard pattern |
| Third-party state package (unsolicited) | `ChangeNotifier` / `ValueNotifier` |
| `ListView` with fixed children list (long) | `ListView.builder` |
| Skipping `dart analyze` | Always run before finishing |
| Generating mocks by default | Prefer fakes/stubs |