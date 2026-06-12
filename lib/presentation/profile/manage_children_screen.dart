import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_children_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/remove_child_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_modal.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_shimmer.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/child_avatar.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/pressable_card.dart';
import 'package:bourgo_arena_mobile/presentation/profile/viewmodels/manage_children_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen for managing children profiles.
class ManageChildrenScreen extends StatefulWidget {
  const ManageChildrenScreen({super.key});

  @override
  State<ManageChildrenScreen> createState() => _ManageChildrenScreenState();
}

class _ManageChildrenScreenState extends State<ManageChildrenScreen> {
  late final ManageChildrenViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ManageChildrenViewModel(
      getChildrenUseCase: locator<GetChildrenUseCase>(),
      removeChildUseCase: locator<RemoveChildUseCase>(),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation(String childId, String childName) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    showDialog(
      context: context,
      builder: (context) => AppModal(
        title: l10n.profileConfirmDeleteChild,
        subtitle: childName,
        icon: Symbols.delete,
        content: Text(
          l10n.profileConfirmDeleteChildMessage(childName),
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          AppModalAction(
            label: l10n.commonCancel,
            onPressed: () => Navigator.pop(context),
          ),
          AppModalAction(
            label: l10n.profileDelete,
            isPrimary: true,
            isDestructive: true,
            onPressed: () async {
              AppHaptics.medium();
              Navigator.pop(context);
              final success = await _viewModel.removeChild(childId);

              if (success) {
                if (context.mounted) {
                  AppHaptics.success();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(l10n.profileChildRemoved),
                        backgroundColor: appColors.statusSuccess,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                }
              } else {
                if (context.mounted) {
                  AppHaptics.error();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          _viewModel.errorMessage ?? l10n.commonErrorOccurred,
                        ),
                        backgroundColor: theme.colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          l10n.profileManageChildren.toUpperCase(),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return RefreshIndicator(
              onRefresh: _viewModel.reloadChildren,
              child: _buildLoadingState(theme, spacing),
            );
          }

          final children = _viewModel.children;

          return RefreshIndicator(
            onRefresh: _viewModel.reloadChildren,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(spacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (children.isEmpty)
                    _buildEmptyState(context, theme, spacing, l10n)
                  else
                    _buildChildrenList(context, children, theme, spacing),
                  SizedBox(height: spacing.xl),
                  FilledButton.icon(
                    onPressed: () async {
                      AppHaptics.light();
                      final childAdded = await context.push<bool>('/add-child');
                      if (childAdded == true) {
                        await _viewModel.reloadChildren();
                      }
                    },
                    icon: const Icon(Symbols.add),
                    label: Text(
                      l10n.profileAddChild.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: spacing.lg),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme, AppSpacing spacing) {
    return AppShimmer(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing.xl),
        children: List.generate(
          4,
          (_) => Padding(
            padding: EdgeInsets.only(bottom: spacing.lg),
            child: Row(
              children: [
                AppShimmer.block(width: 64, height: 64, borderRadius: 32),
                SizedBox(width: spacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmer.block(width: 140, height: 16),
                      SizedBox(height: spacing.sm),
                      AppShimmer.block(width: 80, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    AppSpacing spacing,
    AppLocalizations l10n,
  ) {
    return Padding(
          padding: EdgeInsets.symmetric(vertical: spacing.xxl),
          child: Column(
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Icon(
                  Symbols.groups,
                  size: 56,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: spacing.xl),
              Text(
                l10n.profileNoChildren,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing.md),
              Text(
                l10n.profileNoChildrenDescription,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fade(duration: 300.ms)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutQuad);
  }

  Widget _buildChildrenList(
    BuildContext context,
    List children,
    ThemeData theme,
    AppSpacing spacing,
  ) {
    return Column(
      children: List.generate(children.length, (index) {
        final child = children[index];
        return Padding(
              padding: EdgeInsets.only(bottom: spacing.lg),
              child: _buildChildCard(context, child),
            )
            .animate(delay: (index * 50).ms)
            .fade(duration: 300.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
      }),
    );
  }

  Widget _buildChildCard(BuildContext context, dynamic child) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = AppLocalizations.of(context)!;
    final appColors = theme.extension<AppColors>()!;
    final isFemale = child.gender?.toLowerCase() == 'female';
    final genderLabel = child.gender == null
        ? l10n.profileGenderNotSpecified
        : (isFemale ? l10n.profileFemale : l10n.profileMale);

    return PressableCard(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/child/${child.id}/profile'),
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appColors.bgBorder),
        ),
        child: Row(
          children: [
            Semantics(
              label: genderLabel,
              child: ChildAvatar(
                gender: child.gender,
                size: 64,
                heroTag: 'child-avatar-${child.id}',
              ),
            ),
            SizedBox(width: spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    genderLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                AppHaptics.light();
                final updated = await context.push<bool>(
                  '/edit-child/${child.id}',
                  extra: child,
                );
                if (updated == true) {
                  _viewModel.reloadChildren();
                }
              },
              icon: Icon(Symbols.edit, color: theme.colorScheme.primary),
              tooltip: l10n.profileEdit,
            ),
            IconButton(
              onPressed: () {
                AppHaptics.light();
                _showDeleteConfirmation(child.id, child.name);
              },
              icon: Icon(Symbols.delete, color: theme.colorScheme.error),
              tooltip: l10n.profileDelete,
            ),
          ],
        ),
      ),
    );
  }
}
