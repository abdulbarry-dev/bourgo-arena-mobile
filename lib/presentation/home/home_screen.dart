import 'package:bourgo_arena_mobile/core/constants.dart';
import 'package:bourgo_arena_mobile/data/models/activity.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/activity_card.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/ticker_strip.dart';
import 'package:bourgo_arena_mobile/presentation/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The home screen of Bourgo Arena.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppConstants.appName.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'BlackHanSans',
            fontSize: 20,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => MainLayout.tabController.value = 1,
            icon: const Icon(Symbols.search),
          ),
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Symbols.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Container(
              height: 200,
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REJOINS',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontFamily: 'BlackHanSans',
                      height: 0.9,
                    ),
                  ),
                  Text(
                    'L\'ARENE',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontFamily: 'BlackHanSans',
                      height: 0.9,
                    ),
                  ),
                ],
              ),
            ),

            // Ticker Strip
            TickerStrip(
              text: 'RESERVE TA SESSION • FOOTBALL • PADEL • FITNESS • ',
              backgroundColor: theme.colorScheme.primary,
              textColor: Colors.black,
            ),

            const SizedBox(height: 32),

            // Nos Activités
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NOS ACTIVITÉS',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: 'BlackHanSans',
                      letterSpacing: 1,
                    ),
                  ),
                  TextButton(
                    onPressed: () => MainLayout.tabController.value = 1,
                    child: Text(
                      'VOIR TOUT',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  ActivityCard(
                    title: 'Football',
                    imageUrl:
                        'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=500',
                    onTap: () => context.push(
                      '/booking',
                      extra: Activity(
                        id: 'foot-1',
                        title: 'Football 5vs5',
                        imageUrl:
                            'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=500',
                        price: 100.0,
                        currency: 'TND',
                        category: 'Football',
                        icon: 'sports_soccer',
                        description: 'Terrain synthétique de haute qualité.',
                        features: ['Douches', 'Parking', 'Éclairage'],
                      ),
                    ),
                  ),
                  ActivityCard(
                    title: 'Padel',
                    imageUrl:
                        'https://images.unsplash.com/photo-1626245917164-214273c248fa?q=80&w=500',
                    onTap: () => context.push(
                      '/booking',
                      extra: Activity(
                        id: 'padel-1',
                        title: 'Padel Court',
                        imageUrl:
                            'https://images.unsplash.com/photo-1626245917164-214273c248fa?q=80&w=500',
                        price: 60.0,
                        currency: 'TND',
                        category: 'Padel',
                        icon: 'sports_tennis',
                        description: 'Court panoramique avec éclairage LED.',
                        features: ['Raquettes fournies', 'Vitre panoramique'],
                      ),
                    ),
                  ),
                  ActivityCard(
                    title: 'Fitness',
                    imageUrl:
                        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=500',
                    onTap: () => context.push(
                      '/booking',
                      extra: Activity(
                        id: 'fitness-1',
                        title: 'Salle de Fitness',
                        imageUrl:
                            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=500',
                        price: 20.0,
                        currency: 'TND',
                        category: 'Fitness',
                        icon: 'fitness_center',
                        description:
                            'Accès complet aux machines et poids libres.',
                        features: ['Climatisation', 'Coach disponible'],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Aujourd'hui Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'AUJOURD\'HUI',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontFamily: 'BlackHanSans',
                  letterSpacing: 1,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Placeholder for "Aujourd'hui" items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: 3,
              itemBuilder: (context, index) {
                final titles = [
                  'TOURNOI FLASH',
                  'COURS COLLECTIF',
                  'MATCH AMICAL',
                ];
                final subtitles = [
                  'Football 5vs5 • 18:00',
                  'CrossFit • 19:30',
                  'Padel Mixed • 21:00',
                ];

                return GestureDetector(
                  onTap: () => MainLayout.tabController.value = 2,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 40,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titles[index],
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              subtitles[index],
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Symbols.chevron_right, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
    );
  }
}
