Title: Remove NFC Hikvision / Terminal logic from Flutter apps

Purpose:
- Instruct an autonomous code agent to find and remove any files, screens, widgets, or field-level logic in this repository that are specifically related to Hikvision NFC access or a Hikvision terminal.

Scope:
- Workspace root: the entire Flutter mono-repo (all platforms under `lib/`, `android/`, `ios/`, `macos/`, `windows/`, `linux/`, and platform-specific folders).
- Focus only on code, resources, assets, and configuration that directly reference or implement Hikvision NFC/terminal functionality.
- Do not change unrelated features, business logic, or third-party integrations unless they are directly dependent on the removed code.

Inputs / Arguments:
- `--dry-run` (boolean): when true, only produce a report of files/usages and suggested edits; do not modify files.
- `--apply` (boolean): when true, make changes in a new branch and commit them.
- `--branch-name` (string): optional branch name; default `remove/hikvision-nfc`.
- `--approve-tests` (boolean): allow the agent to run tests; if failing, stop and report.

Search Patterns (use case-insensitive):
- keywords: "Hikvision", "Hik-Vision", "hikvision", "NFC", "nfc", "HIK-", "terminal", "access terminal", "access_control", "hik_access", "hik_"
- RegEx examples: `Hikvision|Hik-Vision|hikvision|\bNFC\b|\bnfc\b|\bterminal\b`
- File-name hints: `*hik*`, `*nfc*`, `*terminal*`, `hikvision*`

High-level Steps the agent must follow:
1. Run a workspace-wide, case-insensitive search for the patterns above and produce a comprehensive list of matches with file paths and line excerpts (dry-run mode).
2. Classify each match as: (a) UI (screens, widgets, fields), (b) business/logic (repositories, services), (c) platform integration (Android/iOS native code, permissions, manifests), (d) assets/config (images, icons, strings, gradle, plist, manifest entries).
3. For each classified item propose one of the actions: `delete file`, `remove widget/field`, `extract-and-remove logic`, `replace with stub`, or `leave (false positive)` with a one-line justification.
4. For UI changes prefer removing the smallest cohesive unit (widget or field) and update callers: remove imports, update DI/registrations, and update navigation routes if a screen is removed.
5. For platform/native integrations (Android/iOS): remove relevant Java/Kotlin/ObjC/Swift files, manifest entries, gradle plugins, and permission uses when safe to do so. Do not remove platform code required by other features.
6. Update localization (`l10n/`) to remove or mark strings related to the removed features.
7. Ensure imports, dependency registrations, and build files are clean (no unused imports, no broken references). Prefer automated safe edits over manual text deletion.
8. Run `flutter analyze` and the test suite (unit/widget/integration) in dry-run mode if requested; if tests fail after applying edits, revert the branch and report failing tests.

Change Procedure (when `--apply` is set):
- Create a new branch named per `--branch-name`.
- Stage changes in small commits grouped by feature area (UI, logic, platform). Commit messages should reference: "remove: Hikvision NFC/terminal - <area>".
- Add a `CHANGES/REMOVE-HIKVISION-NFC.md` file summarizing the removals with file lists and migration notes.
- Run `flutter format` on modified files and `flutter analyze`.
- Run tests; if tests pass, push the branch and open a draft PR with the summary.
- If tests fail or build is broken, do not push; instead include a reproducible failure log and proposed follow-ups.

Safety & Review Requirements:
- Always run in `--dry-run` first and provide a precise, searchable report before applying any edits.
- Back up any file deletions by creating commits; do not permanently delete without a branch/commit.
- If a deletion is ambiguous (could affect security or access control flows), mark it for human review and do not auto-remove.

Output Format (required):
- JSON summary with keys: `matches` (list of {file, line, excerpt, category}), `proposals` (list of {file, action, reason}), `patches` (git-style diffs for proposed edits), `tests` (analyze/test results), `branch` (if created), `pr_url` (if opened).

Example invocations:
- Dry run report:
  - `agent --root . --prompt .prompt.md --dry-run`
- Apply changes with tests and PR:
  - `agent --root . --prompt .prompt.md --apply --branch-name remove/hikvision-nfc --approve-tests`

Notes / Tips for the agent:
- Prefer minimal, reversible edits; err on the side of creating a commit and opening a PR rather than forcing merges.
- Keep a clear audit trail: which files were removed, why, and what replaced them (stubs or route fallbacks).
- If you find third-party packages used exclusively for Hikvision/NFC, propose removing them in a separate follow-up commit and list replacement or rationale.

If anything below is ambiguous, stop and ask a human reviewer.
