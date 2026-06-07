import 'dart:io';

void fixTestFile(String path) {
  final file = File(path);
  if (!file.existsSync()) return;

  var content = file.readAsStringSync();

  if (!content.contains('class MockAuthStateNotifier')) {
    content = content.replaceFirst(
      'void main() {',
      'class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}\n\nvoid main() {',
    );
  }

  if (!content.contains(
    'import \'package:bourgo_arena_mobile/core/di/locator.dart\';',
  )) {
    content =
        'import \'package:bourgo_arena_mobile/core/di/locator.dart\';\n' +
        content;
  }
  if (!content.contains(
    'import \'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart\';',
  )) {
    content =
        'import \'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart\';\n' +
        content;
  }
  if (!content.contains(
    'import \'package:bourgo_arena_mobile/domain/entities/auth_state.dart\';',
  )) {
    content =
        'import \'package:bourgo_arena_mobile/domain/entities/auth_state.dart\';\n' +
        content;
  }

  if (content.contains('setUp(() {')) {
    if (!content.contains('mockAuthStateNotifier = MockAuthStateNotifier();')) {
      content = content.replaceFirst('setUp(() {', '''setUp(() {
    final mockAuthStateNotifier = MockAuthStateNotifier();
    if (!locator.isRegistered<AuthStateNotifier>()) {
      locator.registerSingleton<AuthStateNotifier>(mockAuthStateNotifier);
    }
    when(() => mockAuthStateNotifier.state).thenReturn(AuthState.authenticated);
    when(() => mockAuthStateNotifier.isAuthenticated).thenReturn(true);''');
    }
  }

  file.writeAsStringSync(content);
}

void main() {
  fixTestFile('test/widget/planning/planning_screen_test.dart');
  fixTestFile('test/widget/activities/activities_screen_test.dart');
  fixTestFile(
    'test/widget/planning/course_card_test.dart',
  ); // course card is intercepted too!
}
