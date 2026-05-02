import 'package:bourgo_arena_mobile/core/theme.dart';
import 'package:bourgo_arena_mobile/data/services/settings_service.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/settings/settings_view_model.dart';
import 'package:bourgo_arena_mobile/router.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final settingsService = SettingsService(prefs);
  final settingsViewModel = SettingsViewModel(settingsService);

  runApp(BourgoArenaApp(settingsViewModel: settingsViewModel));
}

/// The root widget of the Bourgo Arena application.
class BourgoArenaApp extends StatelessWidget {
  final SettingsViewModel settingsViewModel;

  /// Creates a [BourgoArenaApp].
  const BourgoArenaApp({super.key, required this.settingsViewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsViewModel,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Bourgo Arena',
          debugShowCheckedModeBanner: false,
          theme: BourgoTheme.lightTheme,
          darkTheme: BourgoTheme.darkTheme,
          themeMode: settingsViewModel.themeMode,
          locale: settingsViewModel.locale,
          routerConfig: createRouter(settingsViewModel),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
