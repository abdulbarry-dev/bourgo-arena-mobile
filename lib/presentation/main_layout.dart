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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => MainLayout.tabController.value = index,
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.colorScheme.surface,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurfaceVariant.withValues(
            alpha: 0.6,
          ),
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Symbols.home),
              label: AppLocalizations.of(context)!.navHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Symbols.sports_soccer),
              label: AppLocalizations.of(context)!.navActivities,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Symbols.calendar_month),
              label: AppLocalizations.of(context)!.navPlanning,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Symbols.person),
              label: AppLocalizations.of(context)!.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
