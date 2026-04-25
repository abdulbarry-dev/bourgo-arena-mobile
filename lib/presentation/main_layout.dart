import 'package:bourgo_arena_mobile/presentation/activities/activities_screen.dart';
import 'package:bourgo_arena_mobile/presentation/food/food_screen.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_screen.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The main layout of the application with bottom navigation.
class MainLayout extends StatefulWidget {
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
    const FoodScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withAlpha(20), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.colorScheme.surface,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: Colors.white.withAlpha(100),
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(icon: Icon(Symbols.home), label: 'ACCUEIL'),
            BottomNavigationBarItem(
              icon: Icon(Symbols.sports_soccer),
              label: 'ACTIVITÉS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Symbols.calendar_month),
              label: 'PLANNING',
            ),
            BottomNavigationBarItem(
              icon: Icon(Symbols.restaurant),
              label: 'FOOD',
            ),
            BottomNavigationBarItem(
              icon: Icon(Symbols.person),
              label: 'PROFIL',
            ),
          ],
        ),
      ),
    );
  }
}
