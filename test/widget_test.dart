import 'package:bourgo_arena_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Onboarding screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BourgoArenaApp());

    // Verify that the onboarding screen displays the brand text.
    expect(find.text('BOURGO'), findsOneWidget);
    expect(find.text('ARENA'), findsOneWidget);
    
    // Verify that the "COMMENCER" button is present.
    expect(find.text('COMMENCER'), findsOneWidget);
  });
}
