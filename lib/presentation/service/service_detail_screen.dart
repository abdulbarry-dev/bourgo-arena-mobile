import 'package:flutter/material.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';

class ServiceDetailScreen extends StatelessWidget {
  final Service? service;
  final String serviceId;

  const ServiceDetailScreen({super.key, this.service, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;

    // In a real app, if service is null, we'd have a ViewModel fetching it by ID.
    // Here we'll build the UI to handle both the loaded state and the fallback.
    final hasData = service != null;
    final title = service?.name ?? 'Loading...';
    final imageUrl = service?.imageUrl;
    final description = service?.description ?? 'No description available.';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Symbols.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(24),
              title: Text(
                title.toUpperCase(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: AppConstants.displayFontFamily,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl != null)
                    PremiumNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover)
                  else
                    Container(
                      color: appColors.bgElevated,
                      child: Icon(
                        Symbols.sports_gymnastics,
                        size: 80,
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                  // Gradient Overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.3),
                          theme.colorScheme.surface,
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Overview Section
                  Text(
                    l10n.homeActivitiesTitle.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Stats / Offerings Grid
                  if (hasData) ...[
                    Text(
                      'AVAILABLE OFFERINGS',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      childAspectRatio: 1.5,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _StatCard(
                          icon: Symbols.workspace_premium,
                          label: 'Plans',
                          count: service!.plansCount,
                          theme: theme,
                          appColors: appColors,
                        ),
                        _StatCard(
                          icon: Symbols.sports_score,
                          label: 'Courses',
                          count: service!.coursesCount,
                          theme: theme,
                          appColors: appColors,
                        ),
                        _StatCard(
                          icon: Symbols.event,
                          label: 'Events',
                          count: service!.eventsCount,
                          theme: theme,
                          appColors: appColors,
                        ),
                        _StatCard(
                          icon: Symbols.fitness_center,
                          label: 'Activities',
                          count: service!.activitiesCount,
                          theme: theme,
                          appColors: appColors,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: hasData
          ? FloatingActionButton.extended(
              onPressed: () {
                // Action to book or view plans.
                // Could open a bottom sheet or push a route.
              },
              backgroundColor: theme.colorScheme.primary,
              icon: const Icon(Symbols.calendar_add_on, color: Colors.black),
              label: const Text(
                'VIEW PLANS',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final ThemeData theme;
  final AppColors appColors;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.theme,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: count > 0
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              Text(
                count.toString(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: count > 0
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: count > 0
                  ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8)
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
