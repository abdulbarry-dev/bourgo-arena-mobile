# Plan: CourseCard Professional Redesign

## Goal
Redesign `CourseCard` to match the `ActivityCard` professional card pattern, then wire it in the Courses tab. Zero data layer changes needed.

## Data Context
- `GET /courses` returns: `id` (string), `name`, `description`, `images[]`, `image_url`, `status`
- Course entity has: `id`, `name`, `description`, `images`, `imageUrl`, `status`
- No `basePrice`, `features`, or `capacity` on courses

## Files to Modify

### 1. `lib/presentation/planning/widgets/course_card.dart` — complete rewrite
Mirror ActivityCard layout adapted for Course data:
- Image section (180px): Stack with PremiumNetworkImage, gradient overlay (transparent → black 0.6), status badge
- Content section (padding 16): title (BlackHanSans, uppercase, w900, 18px), description (bodySmall, 2 lines), "VIEW DETAILS" action label
- Container: rounded(24), bgElevated, border, boxShadow (identical to ActivityCard)
- No feature chips, no price, no capacity (course has no such fields)

### 2. `lib/presentation/activities/activities_screen.dart` — swap _CourseTile for CourseCard
- Replace inline `_CourseTile` widget usage with `CourseCard(course: course, onTap: ...)`
- Remove the inline `_CourseTile` class definition

### 3. No changes needed to:
- `planning_screen.dart` — already uses `CourseCard`, gets the redesign automatically
- `today_course_card.dart` — separate compact variant for home screen
- Data layer — GET /courses flow is already correct
