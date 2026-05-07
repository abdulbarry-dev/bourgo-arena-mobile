import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/data/services/activity_service.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/data/services/settings_service.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:bourgo_arena_mobile/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dependencies
  await initLocator();

  final prefs = await SharedPreferences.getInstance();
  final settingsService = SettingsService(prefs);
  final settingsViewModel = SettingsViewModel(settingsService);

  runApp(
    BourgoArenaApp(
      settingsViewModel: settingsViewModel,
      authStateNotifier: locator<AuthStateNotifier>(),
    ),
  );
}

/// The root widget of the Bourgo Arena application.
class BourgoArenaApp extends StatefulWidget {
  final SettingsViewModel settingsViewModel;
  final AuthStateNotifier authStateNotifier;

  /// Creates a [BourgoArenaApp].
  const BourgoArenaApp({
    super.key,
    required this.settingsViewModel,
    required this.authStateNotifier,
  });

  @override
  State<BourgoArenaApp> createState() => _BourgoArenaAppState();
}

class _BourgoArenaAppState extends State<BourgoArenaApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(
      widget.settingsViewModel,
      widget.authStateNotifier,
      locator<ActivityService>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsViewModel,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Bourgo Arena',
          debugShowCheckedModeBanner: false,
          theme: BourgoTheme.lightTheme,
          darkTheme: BourgoTheme.darkTheme,
          themeMode: widget.settingsViewModel.themeMode,
          locale: widget.settingsViewModel.locale,
          routerConfig: _router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
