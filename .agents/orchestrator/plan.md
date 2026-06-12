# Execution Plan: Codebase Optimization

## Steps
1. **Initialize Workspace Metadata**: Create ORIGINAL_REQUEST.md, BRIEFING.md, progress.md, and PROJECT.md. (Done)
2. **Decompose & Planning**: Define milestones and allocate tasks to subagents. (Done)
3. **Milestone 1: Codebase Exploration**:
   - Dispatch `teamwork_preview_explorer` to perform code search and analyze the current folder structure, layer architecture, and patterns.
   - Retrieve explorer's findings.
4. **Milestone 2: Baseline Verification**:
   - Dispatch `teamwork_preview_worker` to run `dart format --output=none .`, `dart analyze`, and `flutter test`.
   - Retrieve baseline test results and lint errors/warnings.
5. **Milestone 3: Draft Optimization Snippets**:
   - Dispatch `teamwork_preview_explorer` (or a worker if editing files is needed, but here we just need to identify patterns and write a report) to propose 5 before/after code snippets aligning with GEMINI.md (e.g. no print, const constructors, null safety, helper methods returning Widget, manual constructors, etc.).
6. **Milestone 4: Compile Final Report**:
   - Dispatch `teamwork_preview_worker` to write the compilation results to `/home/vortex/Desktop/Projects/bourgo-arena-mobile/optimization_report.md`.
   - Verify the generated file.
7. **Report Completion**: Send message to Sentinel (parent) with the final handoff summary.
