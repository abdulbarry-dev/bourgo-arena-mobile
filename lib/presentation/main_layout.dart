import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/activities/activities_screen.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_screen.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The main layout of the application with bottom navigation.
class MainLayout extends StatefulWidget {
  /// Controller to change the active tab from child screens.
  static final ValueNotifier<int> tabController = ValueNotifier<int>(0);

  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ActivitiesScreen(),
    const PlanningScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = MainLayout.tabController.value;
    MainLayout.tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    MainLayout.tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() => _currentIndex = MainLayout.tabController.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            MainLayout.tabController.value = index,
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.primaryContainer,
        destinations: [
          NavigationDestination(
            icon: const Icon(Symbols.home),
            selectedIcon: Icon(
              Symbols.home,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            label: AppLocalizations.of(context)!.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Symbols.sports_soccer),
            selectedIcon: Icon(
              Symbols.sports_soccer,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            label: AppLocalizations.of(context)!.navActivities,
          ),
          NavigationDestination(
            icon: const Icon(Symbols.calendar_month),
            selectedIcon: Icon(
              Symbols.calendar_month,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            label: AppLocalizations.of(context)!.navPlanning,
          ),
          NavigationDestination(
            icon: const Icon(Symbols.person),
            selectedIcon: Icon(
              Symbols.person,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            label: AppLocalizations.of(context)!.navProfile,
          ),
        ],
      ),
    );
  }
}
