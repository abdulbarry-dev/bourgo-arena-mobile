import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_services_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:bourgo_arena_mobile/presentation/service/services_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late final ServicesViewModel _viewModel;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _viewModel = ServicesViewModel(
      getServicesUseCase: locator<GetServicesUseCase>(),
    );
    _viewModel.addListener(_onViewModelChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _viewModel.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          l10n.servicesTitle.toUpperCase(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontFamily: AppConstants.displayFontFamily,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(theme),
          _buildFilterChips(theme),
          Expanded(child: _buildBody(theme)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        onChanged: _viewModel.setSearchQuery,
        decoration: InputDecoration(
          hintText: l10n.servicesSearchHint,
          hintStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            Symbols.search,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Symbols.close,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _viewModel.setSearchQuery('');
                    _searchFocus.unfocus();
                  },
                )
              : null,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.4,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final filters = [
      (ServiceFilterType.all, l10n.servicesFilterAll),
      (ServiceFilterType.plans, l10n.servicesFilterPlans),
      (ServiceFilterType.courses, l10n.servicesFilterCourses),
      (ServiceFilterType.events, l10n.servicesFilterEvents),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((f) {
            final isSelected = _viewModel.filterType == f.$1;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _ServiceFilterChip(
                label: f.$2,
                isSelected: isSelected,
                onTap: () => _viewModel.setFilterType(f.$1),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    if (_viewModel.isLoading) {
      return RefreshIndicator(
        onRefresh: _viewModel.loadServices,
        displacement: 20,
        color: theme.colorScheme.primary,
        child: _buildSkeletonLoading(theme),
      );
    }

    if (_viewModel.errorMessage != null) {
      return RefreshIndicator(
        onRefresh: _viewModel.loadServices,
        displacement: 20,
        color: theme.colorScheme.primary,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                SizedBox(
                  height: constraints.maxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Symbols.error,
                        size: 48,
                        color: theme.colorScheme.error.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _viewModel.errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _viewModel.loadServices,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          minimumSize: const Size(180, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          l10n.serviceDetailRetry.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    final services = _viewModel.services;

    if (services.isEmpty && _allServicesLoaded()) {
      return RefreshIndicator(
        onRefresh: _viewModel.loadServices,
        displacement: 20,
        color: theme.colorScheme.primary,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: constraints.maxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Symbols.grid_view,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _viewModel.searchQuery.isNotEmpty ||
                                _viewModel.filterType != ServiceFilterType.all
                            ? l10n.servicesNoMatching
                            : l10n.servicesNoAvailable,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFamily: AppConstants.displayFontFamily,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _viewModel.searchQuery.isNotEmpty ||
                                _viewModel.filterType != ServiceFilterType.all
                            ? l10n.servicesAdjustSearch
                            : l10n.servicesCheckBack,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _viewModel.loadServices,
      displacement: 20,
      color: theme.colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        itemCount: services.length + (_viewModel.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= services.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
            );
          }
          final service = services[index];
          return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ServiceCard(
                  service: service,
                  onTap: () {
                    context.push('/services/${service.id}', extra: service);
                  },
                ),
              )
              .animate(delay: (index * 50).ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
        },
      ),
    );
  }

  bool _allServicesLoaded() =>
      !_viewModel.isLoading && _viewModel.state == ServicesLoadState.loaded;

  Widget _buildSkeletonLoading(ThemeData theme) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: List.generate(4, (_) => _SkeletonServiceCard(theme: theme)),
    );
  }
}

class _ServiceFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : appColors.bgElevated,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : appColors.bgBorder,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;

  const _ServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = service.imageUrl != null;
    final stats = [
      if (service.plansCount > 0) '${service.plansCount} plans',
      if (service.coursesCount > 0) '${service.coursesCount} courses',
      if (service.eventsCount > 0) '${service.eventsCount} events',
    ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.3,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 140,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (hasImage)
                    PremiumNetworkImage(
                      imageUrl: service.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      child: Icon(
                        Symbols.grid_view,
                        size: 48,
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.25,
                        ),
                      ),
                    ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.5),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Text(
                      service.name.toUpperCase(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: AppConstants.displayFontFamily,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (service.description != null &&
                      service.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        service.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (stats.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: stats
                          .map(
                            (stat) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                stat,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonServiceCard extends StatelessWidget {
  final ThemeData theme;

  const _SkeletonServiceCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Shimmer.fromColors(
        baseColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        highlightColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 140,
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 160,
                      height: 14,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(
                        3,
                        (_) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            width: 60,
                            height: 22,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
