import 'package:bourgo_arena_mobile/core/theme.dart';
import 'package:bourgo_arena_mobile/data/services/auth_service.dart';
import 'package:bourgo_arena_mobile/data/services/settings_service.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/settings/settings_view_model.dart';
import 'package:bourgo_arena_mobile/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final settingsService = SettingsService(prefs);
  final settingsViewModel = SettingsViewModel(settingsService);

  final authService = AuthService(prefs);
  // Auto-login in Debug mode to speed up development
  await authService.autoLoginDebug();

  runApp(
    BourgoArenaApp(
      settingsViewModel: settingsViewModel,
      authService: authService,
    ),
  );
}

/// The root widget of the Bourgo Arena application.
class BourgoArenaApp extends StatefulWidget {
  final SettingsViewModel settingsViewModel;
  final AuthService authService;

  /// Creates a [BourgoArenaApp].
  const BourgoArenaApp({
    super.key,
    required this.settingsViewModel,
    required this.authService,
  });

  @override
  State<BourgoArenaApp> createState() => _BourgoArenaAppState();
}

class _BourgoArenaAppState extends State<BourgoArenaApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(widget.settingsViewModel, widget.authService);
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
