# REMOVE-HIKVISION-NFC

Summary of automated removals and safe updates performed on 2026-05-27:

What I removed:
- NFC UI: `lib/presentation/nfc/nfc_screen.dart` and `lib/presentation/nfc/nfc_view_model.dart`.
- NFC platform helper: `lib/core/utils/nfc_service.dart`.
- NFC domain usecases: `lib/domain/usecases/nfc/*`.
- NFC domain models: `lib/domain/entities/*nfc*`.
- NFC repository and provider interfaces: `lib/domain/repositories/*nfc*`.
- NFC data implementations, mappers, and generated models: `lib/data/repositories/*nfc*`, `lib/data/mappers/nfc_mapper.dart`, `lib/data/models/*nfc*` and generated `*.g.dart`.
- NFC-related tests under `test/widget/nfc` and `test/data/repositories`.
- Removed the `/nfc` route from `lib/router.dart` and the DI registrations/imports in `lib/core/di/locator.dart`.
- Removed localization keys for NFC from `lib/l10n/app_en.arb` and `lib/l10n/app_fr.arb` and cleaned generated localization getters.

What I changed to keep the app stable:
- Refactored `AccessHistoryViewModel` to remove NFC dependencies and to compute onboarding (PIN) completion using `SessionRepository` only.
- Updated `HistoryScreen` to remove NFC tiles and digital NFC setup navigation. The Security PIN tile remains and continues to reflect the onboarding/pin state.
- Updated DI `locator.dart` to unregister NFC registrations to avoid unresolved factories.

Files added:
- `docs/remove-hikvision-nfc-dryrun.json` (dry-run report updated to include `applied:true` and removed file list)
- `CHANGES/REMOVE-HIKVISION-NFC.md` (this file)

Next recommended steps (manual):
1. Run `flutter format` and `dart analyze` locally to verify no static errors remain.

```bash
flutter format .
dart analyze
```

2. Run unit/widget/integration tests:

```bash
flutter test
```

3. If everything is green, create a branch, commit, and open a PR. Suggested branch name: `remove/hikvision-nfc`.

4. If any tests or analyzer warnings remain, fix them iteratively. I tried to keep changes minimal and targeted to NFC code to avoid breaking onboarding/pin flows.

If you want, I can:
- Create the `remove/hikvision-nfc` branch and commit these changes.
- Run `dart analyze` and `flutter test` here (if you allow running commands).
- Open a draft PR with the changelog and removed files list.
