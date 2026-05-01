import 'package:bourgo_arena_mobile/core/theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BourgoArenaApp());
}

/// The root widget of the Bourgo Arena application.
class BourgoArenaApp extends StatelessWidget {
  /// Creates a [BourgoArenaApp].
  const BourgoArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bourgo Arena',
      debugShowCheckedModeBanner: false,
      theme: BourgoTheme.darkTheme,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
