import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/notifications/notifications_screen.dart';
import 'package:bourgo_arena_mobile/presentation/notifications/notifications_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart' as entity;

class MockNotificationsViewModel extends Mock implements NotificationsViewModel {}

void main() {
  late MockNotificationsViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockNotificationsViewModel();
    when(() => mockViewModel.isLoading).thenReturn(true);
    when(() => mockViewModel.notifications).thenReturn(null);
    when(() => mockViewModel.addListener(any())).thenReturn(null);
    when(() => mockViewModel.removeListener(any())).thenReturn(null);
  });

  Widget createWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: NotificationsScreen(viewModel: mockViewModel),
    );
  }

  testWidgets('shows loading when isLoading true', (tester) async {
    when(() => mockViewModel.isLoading).thenReturn(true);

    await tester.pumpWidget(createWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows empty state when no notifications', (tester) async {
    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.notifications).thenReturn([]);

    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(NotificationsScreen));
    final l10n = AppLocalizations.of(context)!;
    expect(find.text(l10n.notificationsEmpty), findsOneWidget);
  });

  testWidgets('tapping mark all read calls viewModel', (tester) async {
    final n = entity.Notification(
      id: '1',
      title: 't',
      message: 'm',
      timestamp: DateTime.now(),
      type: 'system',
      isRead: false,
    );

    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.notifications).thenReturn([n]);
    when(() => mockViewModel.markAllAsRead()).thenAnswer((_) async {});

    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    final markBtn = find.byType(TextButton);
    expect(markBtn, findsOneWidget);

    await tester.tap(markBtn);
    await tester.pump();

    verify(() => mockViewModel.markAllAsRead()).called(1);
  });
}
