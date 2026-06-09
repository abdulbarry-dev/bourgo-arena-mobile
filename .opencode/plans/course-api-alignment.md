# Plan: Align Course Screens with COURSE_API.md

## Bug 1: Missing `date` in booking request body
**File:** `lib/data/repositories/api_course_repository.dart`
- Add `String date` parameter to `bookSession(String courseId, String sessionId, String date)`
- Change POST body from `{}` to `{'date': date}`

**File:** `lib/domain/repositories/course_repository.dart`
- Add `String date` to abstract `bookSession()` signature

**File:** `lib/domain/usecases/course/enroll_in_course_use_case.dart`
- Add `String date` parameter to `call(String courseId, String sessionId, String date)`

**File:** `lib/presentation/planning/planning_view_model.dart`
- Update `bookSession(String courseId, String sessionId)` → `bookSession(String courseId, String sessionId, String date)`

## Bug 2: No date picker before booking
**File:** `lib/presentation/planning/course_detail_screen.dart`
- When user taps BOOK on a `_SessionTile`:
  1. Show a `showDatePicker` dialog or custom bottom sheet
  2. Only allow dates where `date.weekday == session.dayOfWeek` (API 0=Sun → Dart: 0→7, 1-6→1-6)
  3. Range: today to today+7 days
  4. Disable past dates
  5. After selection, call `_bookSession(courseId, sessionId, date)`

## Bug 3: Course details hidden when sessions endpoint fails
**File:** `lib/presentation/planning/course_detail_screen.dart`
- Restructure `build()` so the top-level check `_errorMessage != null` does NOT gate the entire body
- New structure: always show CustomScrollView with:
  - Image carousel (from `_course.images`)
  - Course name, status badge, description
  - **If `_accessDenied`**: show subscription gate
  - **Else**: show sessions list (or "No upcoming sessions")
- Keep `_isLoading` spinner for initial load
- PremiumErrorState only if `_errorMessage != null && !_accessDenied` (genuine errors, not auth issues)
