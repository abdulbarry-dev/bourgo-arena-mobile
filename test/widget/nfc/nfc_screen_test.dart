import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/digital_nfc_status.dart';
import 'package:bourgo_arena_mobile/domain/entities/physical_nfc_status.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/nfc/nfc_screen.dart';
import 'package:bourgo_arena_mobile/presentation/nfc/nfc_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNfcViewModel extends Mock implements NfcViewModel {}

Widget _buildApp(Widget child) {
  return MaterialApp(
    theme: BourgoTheme.lightTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  late MockNfcViewModel viewModel;

  setUp(() {
    viewModel = MockNfcViewModel();
    when(() => viewModel.addListener(any())).thenReturn(null);
    when(() => viewModel.removeListener(any())).thenReturn(null);
    when(() => viewModel.fetchNfcStatus()).thenAnswer((_) async {});
    when(() => viewModel.setupDigitalNfc()).thenAnswer((_) async {});
    when(() => viewModel.errorMessage).thenReturn(null);
    when(() => viewModel.isLoading).thenReturn(false);
  });

  testWidgets('shows unsupported digital NFC state', (tester) async {
    when(() => viewModel.physicalStatus).thenReturn(
      const PhysicalNfcStatus(
        hasCard: false,
        isReady: false,
        fallbackMethods: ['pin'],
      ),
    );
    when(() => viewModel.digitalStatus).thenReturn(
      const DigitalNfcStatus(
        supported: false,
        configured: false,
        eligible: false,
        isReady: false,
        setupStatus: 'unsupported',
        reasons: ['manufacturer_blocked'],
        fallbackMethods: ['pin'],
      ),
    );

    await tester.pumpWidget(_buildApp(NfcScreen(viewModel: viewModel)));
    await tester.pump();

    expect(find.text('Digital NFC Card'), findsOneWidget);
    expect(
      find.textContaining('cannot be configured as a digital NFC access key'),
      findsOneWidget,
    );
    expect(find.textContaining('manufacturer blocked'), findsOneWidget);
    expect(find.text('Go Back'), findsOneWidget);
  });

  testWidgets('shows ready state and HCE action', (tester) async {
    when(() => viewModel.physicalStatus).thenReturn(
      const PhysicalNfcStatus(
        hasCard: true,
        cardUid: 'A1B2C3D4',
        cardStatus: 'active',
        isReady: true,
      ),
    );
    when(() => viewModel.digitalStatus).thenReturn(
      const DigitalNfcStatus(
        supported: true,
        configured: true,
        eligible: true,
        isReady: true,
        setupStatus: 'completed',
      ),
    );

    await tester.pumpWidget(_buildApp(NfcScreen(viewModel: viewModel)));
    await tester.pump();

    expect(find.text('Status: Active'), findsOneWidget);
    expect(find.text('Status: Ready to use'), findsOneWidget);
    expect(find.text('Start HCE Service'), findsOneWidget);
  });
}
