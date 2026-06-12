# Handoff Report — Baseline Verification

This report establishes the baseline verification of the codebase located at `/home/vortex/Desktop/Projects/bourgo-arena-mobile/`.

## 1. Observation

All commands were executed in the codebase root `/home/vortex/Desktop/Projects/bourgo-arena-mobile/`.

### 1.1 Formatting Check
- **Command:** `dart format --output=none --set-exit-if-changed .`
- **Exit Status Code:** 1
- **Verbatim Output:**
```
Changed lib/core/di/locator.dart
Changed lib/core/services/device_identity_service.dart
Changed lib/core/theme/app_colors.dart
Changed lib/core/theme/app_typography.dart
Changed lib/core/theme/bourgo_theme.dart
Changed lib/data/api/api_client.dart
Changed lib/data/mappers/completed_item_mapper.dart
Changed lib/data/mappers/schedule_item_mapper.dart
Changed lib/data/models/child_profile_model.dart
Changed lib/data/repositories/api_auth_repository.dart
Changed lib/data/repositories/api_event_repository.dart
Changed lib/data/repositories/api_family_repository.dart
Changed lib/domain/entities/app_theme_mode.dart
Changed lib/domain/entities/child_profile.dart
Changed lib/domain/repositories/family_repository.dart
Changed lib/domain/usecases/booking/make_reservation_use_case.dart
Changed lib/domain/usecases/family/get_child_schedule_use_case.dart
Changed lib/presentation/auth/register/family_onboarding_screen.dart
Changed lib/presentation/booking/viewmodels/booking_view_model.dart
Changed lib/presentation/browse/browse_screen.dart
Changed lib/presentation/common/widgets/app_list_item.dart
Changed lib/presentation/common/widgets/app_section_header.dart
Changed lib/presentation/common/widgets/app_shimmer.dart
Changed lib/presentation/common/widgets/child_avatar.dart
Changed lib/presentation/common/widgets/child_selector_sheet.dart
Changed lib/presentation/common/widgets/family_member_widgets.dart
Changed lib/presentation/common/widgets/premium_network_image.dart
Changed lib/presentation/events/bracket_screen.dart
Changed lib/presentation/events/event_detail_screen.dart
Changed lib/presentation/events/events_screen.dart
Changed lib/presentation/events/my_events_screen.dart
Changed lib/presentation/family_child/screens/child_bookings_screen.dart
Changed lib/presentation/family_child/screens/child_completed_screen.dart
Changed lib/presentation/family_child/screens/child_profile_screen.dart
Changed lib/presentation/family_child/screens/child_reservations_screen.dart
Changed lib/presentation/family_child/screens/child_schedule_screen.dart
Changed lib/presentation/family_child/screens/child_sessions_screen.dart
Changed lib/presentation/family_child/screens/child_subscriptions_screen.dart
Changed lib/presentation/family_child/viewmodels/child_bookings_view_model.dart
Changed lib/presentation/family_child/viewmodels/child_completed_view_model.dart
Changed lib/presentation/family_child/viewmodels/child_reservations_view_model.dart
Changed lib/presentation/family_child/viewmodels/child_sessions_view_model.dart
Changed lib/presentation/family_child/viewmodels/child_subscriptions_view_model.dart
Changed lib/presentation/home/home_screen.dart
Changed lib/presentation/payment/payment_selection_view_model.dart
Changed lib/presentation/planning/planning_screen.dart
Changed lib/presentation/profile/manage_children_screen.dart
Changed lib/presentation/profile/plan_detail_screen.dart
Changed lib/presentation/profile/subscription_management_screen.dart
Changed lib/presentation/profile/subscription_screen.dart
Changed lib/presentation/profile/subscription_view_model.dart
Changed lib/presentation/service/service_detail_screen.dart
Changed lib/presentation/service/services_screen.dart
Changed lib/presentation/service/services_view_model.dart
Changed lib/router.dart
Changed test/unit/data/repositories/api_activity_repository_test.dart
Changed test/unit/data/repositories/api_auth_repository_test.dart
Changed test/unit/data/repositories/api_service_repository_test.dart
Changed test/unit/presentation/auth/login/login_view_model_test.dart
Changed test/unit/presentation/auth/otp/otp_view_model_test.dart
Changed test/unit/presentation/planning/planning_view_model_test.dart
Changed test/unit/presentation/profile/profile_view_model_test.dart
Changed test/unit/presentation/settings/settings_view_model_test.dart
Changed test/widget/auth/login_screen_test.dart
Changed test/widget/presentation/profile/profile_screen_test.dart
Changed test/widget/profile/profile_screen_test.dart
Formatted 483 files (66 changed) in 4.33 seconds.
```

### 1.2 Lint & Code Analysis
- **Command:** `dart analyze`
- **Exit Status Code:** 2
- **Verbatim Output:**
```
Analyzing bourgo-arena-mobile...

warning - lib/firebase_options.dart:2:8 - Unused import:
          'package:flutter/foundation.dart'. Try removing the import directive.
          - unused_import
warning - lib/presentation/common/widgets/animated_counter.dart:32:11 - The
          value of the field '_targetDecimal' isn't used. Try removing the
          field, or using it. - unused_field
warning - lib/presentation/common/widgets/app_toast.dart:57:11 - The value of
          the local variable 'controller' isn't used. Try removing the variable
          or using it. - unused_local_variable
warning - lib/presentation/family_child/screens/child_reservations_screen.dart:337:15
          - The declaration '_showQrCodeDialog' isn't referenced. Try removing
          the declaration of '_showQrCodeDialog'. - unused_element
warning - lib/presentation/profile/add_edit_child_screen.dart:339:11 - The value
          of the local variable 'hasAvatar' isn't used. Try removing the
          variable or using it. - unused_local_variable
warning - lib/presentation/profile/widgets/subscription_history_tile.dart:97:40
          - Dead code. Try removing the code, or fixing the code before it so
          that it can be reached. - dead_code
warning - lib/presentation/profile/widgets/subscription_history_tile.dart:97:43
          - The left operand can't be null, so the right operand is never
          executed. Try removing the operator and the right operand. -
          dead_null_aware_expression
warning - test/integration/register_complete_integration_test.dart:181:44 -
          Unnecessary cast. Try removing the cast. - unnecessary_cast
warning - test/unit/data/mappers/course_mapper_test.dart:4:8 - Unused import:
          'package:bourgo_arena_mobile/domain/entities/course.dart'. Try
          removing the import directive. - unused_import
warning - test/unit/data/repositories/api_course_repository_test.dart:4:8 -
          Unused import:
          'package:bourgo_arena_mobile/domain/core/app_error_code.dart'. Try
          removing the import directive. - unused_import
warning - test/unit/data/repositories/api_family_repository_test.dart:3:8 -
          Unused import:
          'package:bourgo_arena_mobile/data/api/api_exceptions.dart'. Try
          removing the import directive. - unused_import
warning - test/unit/data/repositories/api_payment_repository_test.dart:50:13 -
          The value of the local variable 'payments' isn't used. Try removing
          the variable or using it. - unused_local_variable
warning - test/unit/domain/usecases/booking/make_reservation_use_case_test.dart:3:8
          - Unused import:
          'package:bourgo_arena_mobile/domain/entities/reservation.dart'. Try
          removing the import directive. - unused_import
warning - test/unit/presentation/auth/auth_state_notifier_test.dart:12:8 -
          Unused import: 'package:bourgo_arena_mobile/domain/core/failure.dart'.
          Try removing the import directive. - unused_import
warning - test/unit/presentation/auth/auth_state_notifier_test.dart:13:8 -
          Unused import:
          'package:bourgo_arena_mobile/domain/core/app_error_code.dart'. Try
          removing the import directive. - unused_import
warning - test/unit/presentation/profile/profile_view_model_test.dart:7:8 -
          Unused import:
          'package:bourgo_arena_mobile/domain/entities/reservation.dart'. Try
          removing the import directive. - unused_import
   info - lib/data/api/api_client.dart:323:9 - Use the null-aware marker '?'
          rather than a null check via an 'if'. Try using '?'. -
          use_null_aware_elements
   info - lib/data/repositories/api_auth_repository.dart:268:17 - Use the
          null-aware marker '?' rather than a null check via an 'if'. Try using
          '?'. - use_null_aware_elements
   info - lib/data/repositories/api_auth_repository.dart:555:9 - Use the
          null-aware marker '?' rather than a null check via an 'if'. Try using
          '?'. - use_null_aware_elements
   info - lib/data/repositories/api_device_registration_repository.dart:29:19 -
          Use the null-aware marker '?' rather than a null check via an 'if'.
          Try using '?'. - use_null_aware_elements
   info - lib/data/repositories/api_payment_repository.dart:89:9 - Statements in
          an if should be enclosed in a block. Try wrapping the statement in a
          block. - curly_braces_in_flow_control_structures
   info - lib/data/repositories/api_payment_repository.dart:91:9 - Statements in
          an if should be enclosed in a block. Try wrapping the statement in a
          block. - curly_braces_in_flow_control_structures
   info - lib/presentation/common/widgets/app_card.dart:61:7 - The 'child'
          argument should be last in widget constructor invocations. Try moving
          the argument to the end of the argument list. -
          sort_child_properties_last
   info - lib/presentation/common/widgets/app_card.dart:79:7 - The 'child'
          argument should be last in widget constructor invocations. Try moving
          the argument to the end of the argument list. -
          sort_child_properties_last
   info - lib/presentation/common/widgets/confirm_action_modal.dart:142:55 -
          Don't use 'BuildContext's across async gaps. Try rewriting the code to
          not use the 'BuildContext', or guard the use with a 'mounted' check. -
          use_build_context_synchronously
   info - lib/presentation/events/event_detail_screen.dart:194:7 - Statements in
          an if should be enclosed in a block. Try wrapping the statement in a
          block. - curly_braces_in_flow_control_structures
   info - lib/presentation/events/event_detail_screen.dart:199:7 - Statements in
          an if should be enclosed in a block. Try wrapping the statement in a
          block. - curly_braces_in_flow_control_structures
   info - lib/presentation/events/event_detail_screen.dart:215:7 - Statements in
          an if should be enclosed in a block. Try wrapping the statement in a
          block. - curly_braces_in_flow_control_structures
   info - lib/presentation/events/event_detail_screen.dart:289:31 - Unnecessary
          use of multiple underscores. Try using '_'. - unnecessary_underscores
   info - lib/presentation/events/event_detail_screen.dart:289:35 - Unnecessary
          use of multiple underscores. Try using '_'. - unnecessary_underscores
   info - lib/presentation/events/events_screen.dart:205:29 - Don't use
          'BuildContext's across async gaps, guarded by an unrelated 'mounted'
          check. Guard a 'State.context' use with a 'mounted' check on the
          State, and other BuildContext use with a 'mounted' check on the
          BuildContext. - use_build_context_synchronously
   info - lib/presentation/events/events_screen.dart:208:48 - Don't use
          'BuildContext's across async gaps, guarded by an unrelated 'mounted'
          check. Guard a 'State.context' use with a 'mounted' check on the
          State, and other BuildContext use with a 'mounted' check on the
          BuildContext. - use_build_context_synchronously
   info - lib/presentation/events/events_screen.dart:212:33 - Don't use
          'BuildContext's across async gaps, guarded by an unrelated 'mounted'
          check. Guard a 'State.context' use with a 'mounted' check on the
          State, and other BuildContext use with a 'mounted' check on the
          BuildContext. - use_build_context_synchronously
   info - lib/presentation/planning/course_detail_screen.dart:55:11 - Statements
          in an if should be enclosed in a block. Try wrapping the statement in
          a block. - curly_braces_in_flow_control_structures
   info - lib/presentation/planning/course_detail_screen.dart:445:30 -
          Unnecessary use of multiple underscores. Try using '_'. -
          unnecessary_underscores
   info - lib/presentation/planning/course_detail_screen.dart:445:34 -
          Unnecessary use of multiple underscores. Try using '_'. -
          unnecessary_underscores
   info - lib/presentation/profile/subscription_screen.dart:429:7 - Statements
          in an if should be enclosed in a block. Try wrapping the statement in
          a block. - curly_braces_in_flow_control_structures
   info - test/integration/register_complete_integration_test.dart:180:9 - Don't
          invoke 'print' in production code. Try using a logging framework. -
          avoid_print

38 issues found.
```

### 1.3 Test Suite Execution
- **Command:** `flutter test`
- **Exit Status Code:** 1
- **Verbatim Output of Failures (from exception blocks):**

#### 1.3.1 Profile Screen Test
- **File:** `test/widget/profile/profile_screen_test.dart`
- **Test Description:** `shows user data when fetch is successful`
- **Error Exception:**
```
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following assertion was thrown running a test:
pumpAndSettle timed out

When the exception was thrown, this was the stack:
#0      WidgetTester.pumpAndSettle.<anonymous closure> (package:flutter_test/src/widget_tester.dart:717:11)
<asynchronous suspension>
#1      TestAsyncUtils.guard.<anonymous closure> (package:flutter_test/src/test_async_utils.dart:130:27)
<asynchronous suspension>
#2      main.<anonymous closure>.<anonymous closure> (file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/test/widget/profile/profile_screen_test.dart:294:7)
<asynchronous suspension>
#3      testWidgets.<anonymous closure>.<anonymous closure> (package:flutter_test/src/widget_tester.dart:192:15)
<asynchronous suspension>
#4      TestWidgetsFlutterBinding._runTestBody (package:flutter_test/src/binding.dart:1952:5)
<asynchronous suspension>
<asynchronous suspension>
(elided one frame from package:stack_trace)

The test description was:
  shows user data when fetch is successful
════════════════════════════════════════════════════════════════════════════════════════════════════
```

#### 1.3.2 Activities Screen Test (Failure 1)
- **File:** `test/widget/presentation/activities/activities_screen_test.dart`
- **Test Description:** `BrowseScreen Widget Tests shows EmptyState for courses and GuestAuthState for reservations when unauthenticated`
- **Error Exception:**
```
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following TestFailure was thrown running a test:
Expected: exactly one matching candidate
  Actual: _TypeWidgetFinder:<Found 0 widgets with type "EmptyState": []>
   Which: means none were found but one was expected

When the exception was thrown, this was the stack:
#4      main.<anonymous closure>.<anonymous closure> (file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/test/widget/presentation/activities/activities_screen_test.dart:114:9)
<asynchronous suspension>
#5      testWidgets.<anonymous closure>.<anonymous closure> (package:flutter_test/src/widget_tester.dart:192:15)
<asynchronous suspension>
#6      TestWidgetsFlutterBinding._runTestBody (package:flutter_test/src/binding.dart:1952:5)
<asynchronous suspension>
<asynchronous suspension>
(elided one frame from package:stack_trace)

This was caught by the test expectation on the following line:
  file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/test/widget/presentation/activities/activities_screen_test.dart line 114
The test description was:
  shows EmptyState for courses and GuestAuthState for reservations when unauthenticated
════════════════════════════════════════════════════════════════════════════════════════════════════
```

#### 1.3.3 Activities Screen Test (Failure 2)
- **File:** `test/widget/presentation/activities/activities_screen_test.dart`
- **Test Description:** `BrowseScreen Widget Tests shows EmptyState for reservations when authenticated but no reservations exist`
- **Error Exception:**
```
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following assertion was thrown running a test:
The finder "Found 0 widgets with text "My Reservations": []" (used in a call to "tap()") could not
find any matching widgets.

When the exception was thrown, this was the stack:
#0      WidgetController._getElementPoint (package:flutter_test/src/controller.dart:2095:7)
#1      WidgetController.getCenter (package:flutter_test/src/controller.dart:1947:12)
#2      WidgetController.tap (package:flutter_test/src/controller.dart:1080:7)
#3      main.<anonymous closure>.<anonymous closure> (file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/test/widget/presentation/activities/activities_screen_test.dart:134:22)
<asynchronous suspension>
#4      testWidgets.<anonymous closure>.<anonymous closure> (package:flutter_test/src/widget_tester.dart:192:15)
<asynchronous suspension>
#5      TestWidgetsFlutterBinding._runTestBody (package:flutter_test/src/binding.dart:1952:5)
<asynchronous suspension>
<asynchronous suspension>
(elided one frame from package:stack_trace)

The test description was:
  shows EmptyState for reservations when authenticated but no reservations exist
════════════════════════════════════════════════════════════════════════════════════════════════════
```

#### 1.3.4 Booking Flow Widget Test (Step 1)
- **File:** `test/widget/presentation/booking/booking_flow_widget_test.dart`
- **Test Description:** `BookingFlowScreen Widget Tests Step 1: shows activity list and handles selection`
- **Error Exception:**
```
══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════
The following _TypeError was thrown building ActivityCard(dirty, dependencies:
[InheritedCupertinoTheme, _InheritedTheme, _LocalizationsScope-[GlobalKey#e22a5]]):
Null check operator used on a null value

The relevant error-causing widget was:
  ActivityCard
  ActivityCard:file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/booking/steps/select_sport_step.dart:24:18

When the exception was thrown, this was the stack:
#0      ActivityCard.build (package:bourgo_arena_mobile/presentation/home/widgets/activity_card.dart:24:51)
...
════════════════════════════════════════════════════════════════════════════════════════════════════
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following TestFailure was thrown running a test:
Expected: exactly one matching candidate
  Actual: _TextWidgetFinder:<Found 0 widgets with text "TEST SPORT": []>
   Which: means none were found but one was expected

When the exception was thrown, this was the stack:
#4      main.<anonymous closure>.<anonymous closure> (file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/test/widget/presentation/booking/booking_flow_widget_test.dart:108:7)
...
════════════════════════════════════════════════════════════════════════════════════════════════════
```

#### 1.3.5 Booking Flow Widget Test (Step 2)
- **File:** `test/widget/presentation/booking/booking_flow_widget_test.dart`
- **Test Description:** `BookingFlowScreen Widget Tests Step 2: shows time slots and handles navigation`
- **Error Exception:**
```
══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════
The following _TypeError was thrown building ActivityDetailStep(dirty, dependencies:
[InheritedCupertinoTheme, _InheritedTheme, _LocalizationsScope-[GlobalKey#1fc1c]]):
Null check operator used on a null value

The relevant error-causing widget was:
  ActivityDetailStep
  ActivityDetailStep:file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/booking/booking_flow_screen.dart:149:16

When the exception was thrown, this was the stack:
#0      ActivityDetailStep.build (package:bourgo_arena_mobile/presentation/booking/steps/activity_detail_step.dart:25:51)
...
════════════════════════════════════════════════════════════════════════════════════════════════════
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following TestFailure was thrown running a test:
Expected: exactly one matching candidate
  Actual: _TextWidgetFinder:<Found 0 widgets with text "10:00": []>
   Which: means none were found but one was expected

When the exception was thrown, this was the stack:
#4      main.<anonymous closure>.<anonymous closure> (file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/test/widget/presentation/booking/booking_flow_widget_test.dart:126:7)
...
════════════════════════════════════════════════════════════════════════════════════════════════════
```

#### 1.3.6 Booking Flow Widget Test (Step 3)
- **File:** `test/widget/presentation/booking/booking_flow_widget_test.dart`
- **Test Description:** `BookingFlowScreen Widget Tests Step 3: shows confirmation summary and handles payment`
- **Error Exception:**
```
══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════
The following _TypeError was thrown building _DatePicker(dirty, dependencies:
[InheritedCupertinoTheme, _InheritedTheme, _LocalizationsScope-[GlobalKey#7f9f9]]):
Null check operator used on a null value

The relevant error-causing widget was:
  _DatePicker
  _DatePicker:file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/lib/presentation/booking/steps/select_time_step.dart:40:11

When the exception was thrown, this was the stack:
#0      _DatePicker.build (package:bourgo_arena_mobile/presentation/booking/steps/select_time_step.dart:118:51)
...
════════════════════════════════════════════════════════════════════════════════════════════════════
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following TestFailure was thrown running a test:
Expected: exactly one matching candidate
  Actual: _TextWidgetFinder:<Found 0 widgets with text "25.00 €": []>
   Which: means none were found but one was expected

When the exception was thrown, this was the stack:
#4      main.<anonymous closure>.<anonymous closure> (file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/test/widget/presentation/booking/booking_flow_widget_test.dart:165:7)
...
════════════════════════════════════════════════════════════════════════════════════════════════════
```

#### 1.3.7 Home Screen Test
- **File:** `test/widget/home/home_screen_test.dart`
- **Test Description:** `shows section headers after data loads`
- **Error Exception:**
```
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following TestFailure was thrown running a test:
Expected: exactly one matching candidate
  Actual: _TextWidgetFinder:<Found 0 widgets with text "COURSES": []>
   Which: means none were found but one was expected

When the exception was thrown, this was the stack:
#4      main.<anonymous closure> (file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/test/widget/home/home_screen_test.dart:80:5)
...
════════════════════════════════════════════════════════════════════════════════════════════════════
```

#### 1.3.8 Notifications Screen Test (Failure 1)
- **File:** `test/widget/notifications/notifications_screen_test.dart`
- **Test Description:** `shows empty state when no notifications`
- **Error Exception:**
```
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following TestFailure was thrown running a test:
Expected: exactly one matching candidate
  Actual: _TextWidgetFinder:<Found 0 widgets with text "No notifications for now.": []>
   Which: means none were found but one was expected

When the exception was thrown, this was the stack:
#4      main.<anonymous closure> (file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/test/widget/notifications/notifications_screen_test.dart:52:5)
...
════════════════════════════════════════════════════════════════════════════════════════════════════
```

#### 1.3.9 Notifications Screen Test (Failure 2)
- **File:** `test/widget/notifications/notifications_screen_test.dart`
- **Test Description:** `tapping mark all read calls viewModel`
- **Error Exception:**
```
══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════
The following _TypeError was thrown building:
type 'Null' is not a subtype of type 'bool'

When the exception was thrown, this was the stack:
#0      MockNotificationsViewModel.isLoadingMore (file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/test/widget/notifications/notifications_screen_test.dart:11:7)
#1      _NotificationsScreenState._buildBody.<anonymous closure> (package:bourgo_arena_mobile/presentation/notifications/notifications_screen.dart:259:24)
...
════════════════════════════════════════════════════════════════════════════════════════════════════
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following TestFailure was thrown running a test:
Expected: exactly one matching candidate
  Actual: _TypeWidgetFinder:<Found 0 widgets with type "TextButton": []>
   Which: means none were found but one was expected

When the exception was thrown, this was the stack:
#4      main.<anonymous closure> (file:///home/vortex/Desktop/Projects/bourgo-arena-mobile/test/widget/notifications/notifications_screen_test.dart:74:5)
...
════════════════════════════════════════════════════════════════════════════════════════════════════
```

## 2. Logic Chain

The baseline findings were established by performing sequential, non-destructive check operations directly in the project workspace root:
1. Checked code formatting status: Executed `dart format --output=none --set-exit-if-changed .`, which detected that **66 files** need to be formatted out of 483 files analyzed, resulting in exit code 1.
2. Ran static code analyzer: Executed `dart analyze` which yielded **38 issues** (16 warnings and 22 info statements), resulting in exit code 2.
3. Executed test suite: Executed `flutter test` which ran a total of **490 tests**. 481 tests successfully passed while **9 tests** failed, resulting in exit code 1.
4. Compiled the outputs: The truncated stdout blocks were verified using direct file inspection of raw background task logs.

## 3. Caveats

- Background task stdout for `dart analyze` and `flutter test` was truncated due to output size limitations. The complete raw log files were retrieved and read from `.system_generated/tasks/` to guarantee absolute correctness and list every issue verbatim.
- No code modification or fixes were applied as this task strictly requests baseline verification and reporting.

## 4. Conclusion

The codebase currently contains:
1. **Formatting Violations:** 66 unformatted Dart files (Exit Code 1).
2. **Lint & Code Analysis Violations:** 38 issues (16 warnings, 22 infos) (Exit Code 2).
3. **Test Suite Failures:** 9 failing widget tests out of a total of 490 tests (481 pass, 9 fail) (Exit Code 1).

## 5. Verification Method

To independently verify these results, run the following commands in the workspace root directory:
- **Formatting:** `dart format --output=none --set-exit-if-changed .`
- **Lint/Analyzer:** `dart analyze`
- **Tests:** `flutter test`
