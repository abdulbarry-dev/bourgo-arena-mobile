import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeSettingsViewModel {
  bool deleteCalled = false;

  Future<bool> deleteAccount({required String password}) async {
    deleteCalled = true;
    return true;
  }
}

void main() {
  testWidgets('Delete dialog appears and blocks deletion when password empty', (
    WidgetTester tester,
  ) async {
    final fakeVm = FakeSettingsViewModel();

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              body: Center(
                child: OutlinedButton(
                  onPressed: () {
                    final passwordController = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (context, setState) => AppModal(
                          title: l10n.settingsConfirmDeleteTitle,
                          subtitle: l10n.settingsDeleteAccount,
                          icon: Icons.warning,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(l10n.settingsConfirmDeleteMessage),
                              const SizedBox(height: 12),
                              AuthTextField(
                                label: l10n.passwordCurrentLabel,
                                hint: l10n.passwordCurrentHint,
                                controller: passwordController,
                                isPassword: true,
                                leadingIcon: Icons.lock,
                              ),
                            ],
                          ),
                          actions: [
                            AppModalAction(
                              label: l10n.settingsCancel,
                              onPressed: () => Navigator.pop(context),
                            ),
                            AppModalAction(
                              label: l10n.settingsDelete,
                              isPrimary: true,
                              isDestructive: true,
                              onPressed: () async {
                                final pwd = passwordController.text.trim();
                                if (pwd.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.settingsConfirmDeleteMessage,
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                await fakeVm.deleteAccount(password: pwd);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text('Delete Account'),
                ),
              ),
            );
          },
        ),
      ),
    );

    // Open the dialog
    await tester.tap(find.text('Delete Account'));
    await tester.pumpAndSettle();

    // Dialog title should be visible
    expect(find.text('Delete Account?'), findsOneWidget);

    // Tap the DELETE button without entering password
    expect(find.widgetWithText(ElevatedButton, 'DELETE'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'DELETE'));
    await tester.pumpAndSettle();

    // The fake delete should not have been called and the dialog should remain.
    expect(fakeVm.deleteCalled, isFalse);
    expect(find.text('Delete Account?'), findsOneWidget);
  });
}
