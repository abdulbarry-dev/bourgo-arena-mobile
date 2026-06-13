import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_shimmer.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/child_avatar.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/viewmodels/child_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChildProfileScreen extends StatefulWidget {
  final String childId;

  const ChildProfileScreen({super.key, required this.childId});

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  late final ChildProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ChildProfileViewModel(
      getChildProfileUseCase: locator<GetChildProfileUseCase>(),
    );
    _viewModel.load(widget.childId);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final appColors = theme.extension<AppColors>()!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final profile = _viewModel.profile;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: SubScreenAppBar(title: profile?.name.toUpperCase() ?? ''),
          body: _viewModel.isLoading && profile == null
              ? _buildLoadingState(theme, spacing, appColors)
              : RefreshIndicator(
                  onRefresh: () => _viewModel.load(widget.childId),
                  color: theme.colorScheme.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(spacing.lg),
                    child: profile == null
                        ? _buildErrorState(theme, spacing)
                        : _buildContent(
                            context,
                            profile,
                            theme,
                            spacing,
                            appColors,
                          ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    dynamic profile,
    ThemeData theme,
    AppSpacing spacing,
    AppColors appColors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileHeader(profile, theme, spacing, appColors),
        SizedBox(height: spacing.xl),
        if (profile.hasActiveSubscription && profile.activeSubscription != null)
          _buildActiveSubscriptionCard(profile, theme, spacing, appColors)
              .animate()
              .fade(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
        SizedBox(height: spacing.xl),
        _buildActionButtons(context, theme, spacing, appColors),
      ],
    );
  }

  Widget _buildProfileHeader(
    dynamic profile,
    ThemeData theme,
    AppSpacing spacing,
    AppColors appColors,
  ) {
    return Container(
          width: double.infinity,
          padding: EdgeInsets.all(spacing.xl),
          decoration: BoxDecoration(
            color: appColors.bgElevated,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: appColors.bgBorder),
          ),
          child: Column(
            children: [
              ChildAvatar(
                gender: profile.gender,
                size: 96,
                heroTag: 'child-avatar-${widget.childId}',
              ),
              SizedBox(height: spacing.md),
              Text(
                profile.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: spacing.xxs),
              Text(
                '${profile.firstName} ${profile.lastName}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: spacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _InfoChip(
                    icon: Symbols.cake,
                    label:
                        '${profile.birthDate.day}/${profile.birthDate.month}/${profile.birthDate.year}',
                    theme: theme,
                  ),
                  SizedBox(width: spacing.sm),
                  if (profile.gender != null)
                    _InfoChip(
                      icon: profile.gender == 'female'
                          ? Symbols.female
                          : Symbols.male,
                      label: profile.gender!.toUpperCase(),
                      theme: theme,
                    ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fade(duration: 400.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
  }

  Widget _buildActiveSubscriptionCard(
    dynamic profile,
    ThemeData theme,
    AppSpacing spacing,
    AppColors appColors,
  ) {
    final sub = profile.activeSubscription;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Symbols.workspace_premium,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: spacing.sm),
              Text(
                AppLocalizations.of(
                  context,
                )!.familyChildProfileActiveSubscription,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Text(
            sub.plan?.name?.toUpperCase() ?? '',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: spacing.xs),
          if (sub.daysRemaining != null)
            Text(
              '${sub.daysRemaining} ${AppLocalizations.of(context)!.familyChildProfileDaysRemainingText}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          SizedBox(height: spacing.sm),
          Row(
            children: [
              Expanded(
                child: _DateLabel(
                  label: AppLocalizations.of(context)!.familyChildProfileStart,
                  date: sub.startsAt,
                  theme: theme,
                ),
              ),
              SizedBox(width: spacing.xs),
              Icon(
                Symbols.arrow_forward,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: spacing.xs),
              Expanded(
                child: _DateLabel(
                  label: AppLocalizations.of(context)!.familyChildProfileEnd,
                  date: sub.endsAt,
                  theme: theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    ThemeData theme,
    AppSpacing spacing,
    AppColors appColors,
  ) {
    final childId = widget.childId;

    return Column(
      children: [
        _ActionButton(
          icon: Symbols.calendar_month,
          label: AppLocalizations.of(context)!.familyChildProfileScheduleButton,
          onTap: () => context.push('/child/$childId/schedule'),
          theme: theme,
          spacing: spacing,
          appColors: appColors,
        ).animate().fade(duration: 300.ms).slideY(begin: 0.05, end: 0),
        SizedBox(height: spacing.md),
        _ActionButton(
              icon: Symbols.workspace_premium,
              label: AppLocalizations.of(
                context,
              )!.familyChildProfileSubscriptionsButton,
              onTap: () => context.push('/child/$childId/subscriptions'),
              theme: theme,
              spacing: spacing,
              appColors: appColors,
            )
            .animate(delay: 50.ms)
            .fade(duration: 300.ms)
            .slideY(begin: 0.05, end: 0),
        SizedBox(height: spacing.md),
        _ActionButton(
              icon: Symbols.event_note,
              label: AppLocalizations.of(
                context,
              )!.familyChildProfileBookingsButton,
              onTap: () => context.push('/child/$childId/bookings'),
              theme: theme,
              spacing: spacing,
              appColors: appColors,
            )
            .animate(delay: 100.ms)
            .fade(duration: 300.ms)
            .slideY(begin: 0.05, end: 0),
        SizedBox(height: spacing.md),
        _ActionButton(
              icon: Symbols.sports,
              label: AppLocalizations.of(
                context,
              )!.familyChildProfileSessionsButton,
              onTap: () => context.push('/child/$childId/sessions'),
              theme: theme,
              spacing: spacing,
              appColors: appColors,
            )
            .animate(delay: 150.ms)
            .fade(duration: 300.ms)
            .slideY(begin: 0.05, end: 0),
        SizedBox(height: spacing.md),
        _ActionButton(
              icon: Symbols.list_alt,
              label: AppLocalizations.of(
                context,
              )!.familyChildProfileReservationsButton,
              onTap: () => context.push('/child/$childId/reservations'),
              theme: theme,
              spacing: spacing,
              appColors: appColors,
            )
            .animate(delay: 200.ms)
            .fade(duration: 300.ms)
            .slideY(begin: 0.05, end: 0),
        SizedBox(height: spacing.md),
        _ActionButton(
              icon: Symbols.check_circle,
              label: AppLocalizations.of(
                context,
              )!.familyChildProfileCompletedButton,
              onTap: () => context.push('/child/$childId/completed'),
              theme: theme,
              spacing: spacing,
              appColors: appColors,
            )
            .animate(delay: 250.ms)
            .fade(duration: 300.ms)
            .slideY(begin: 0.05, end: 0),
      ],
    );
  }

  Widget _buildErrorState(ThemeData theme, AppSpacing spacing) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xxl),
        child: Column(
          children: [
            Icon(Symbols.error, size: 64, color: theme.colorScheme.error),
            SizedBox(height: spacing.lg),
            Text(
              _viewModel.errorMessage ??
                  AppLocalizations.of(context)!.familyChildProfileErrorFallback,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: spacing.lg),
            FilledButton.icon(
              onPressed: () => _viewModel.load(widget.childId),
              icon: const Icon(Symbols.refresh, size: 20),
              label: Text(
                AppLocalizations.of(context)!.familyChildProfileRetryButton,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(
    ThemeData theme,
    AppSpacing spacing,
    AppColors appColors,
  ) {
    return AppShimmer(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(spacing.xl),
              decoration: BoxDecoration(
                color: appColors.bgElevated,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: appColors.bgBorder),
              ),
              child: Column(
                children: [
                  AppShimmer.circle(size: 96),
                  SizedBox(height: spacing.md),
                  AppShimmer.block(width: 160, height: 24, borderRadius: 8),
                  SizedBox(height: spacing.sm),
                  AppShimmer.block(width: 120, height: 16, borderRadius: 6),
                  SizedBox(height: spacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppShimmer.block(
                        width: 100,
                        height: 28,
                        borderRadius: 14,
                      ),
                      SizedBox(width: spacing.sm),
                      AppShimmer.block(width: 80, height: 28, borderRadius: 14),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.xl),
            Column(
              children: List.generate(
                5,
                (_) => Padding(
                  padding: EdgeInsets.only(bottom: spacing.md),
                  child: AppShimmer.block(
                    width: double.infinity,
                    height: 56,
                    borderRadius: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          SizedBox(width: spacing.xxs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateLabel extends StatelessWidget {
  final String label;
  final String? date;
  final ThemeData theme;

  const _DateLabel({
    required this.label,
    required this.date,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: spacing.xxs),
          Text(
            date ?? '—',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ThemeData theme;
  final AppSpacing spacing;
  final AppColors appColors;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
    required this.spacing,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appColors.bgBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 24),
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            Icon(
              Symbols.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
