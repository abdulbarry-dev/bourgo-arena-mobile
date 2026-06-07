import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_children_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/remove_child_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_modal.dart';
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
              Navigator.pop(context);
              final success = await _viewModel.removeChild(childId);

              if (success) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.profileChildRemoved),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _viewModel.errorMessage ?? l10n.commonErrorOccurred,
                      ),
                      backgroundColor: theme.colorScheme.error,
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
      appBar: AppBar(
        title: Text(
          l10n.profileManageChildren,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final children = _viewModel.children;

          return SingleChildScrollView(
            padding: EdgeInsets.all(spacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (children.isEmpty)
                  _buildEmptyState(context, theme, spacing, l10n)
                else
                  _buildChildrenList(context, children, theme, spacing),
                SizedBox(height: spacing.xl),
                ElevatedButton.icon(
                  onPressed: () async {
                    final childAdded = await context.push<bool>('/add-child');
                    if (childAdded == true) {
                      await _viewModel.reloadChildren();
                    }
                  },
                  icon: const Icon(Symbols.add),
                  label: Text(l10n.profileAddChild),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: spacing.lg),
                  ),
                ),
              ],
            ),
          );
        },
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
      padding: EdgeInsets.symmetric(vertical: spacing.xl),
      child: Column(
        children: [
          Icon(
            Symbols.groups,
            size: 80,
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
          SizedBox(height: spacing.lg),
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
    );
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

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withOpacity(0.1),
            ),
            child: Center(
              child: Icon(
                child.gender?.toLowerCase() == 'female'
                    ? Symbols.girl
                    : Symbols.boy,
                color: theme.colorScheme.primary,
                size: 32,
              ),
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
                  child.gender ?? 'Not specified',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
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
                onPressed: () => _showDeleteConfirmation(child.id, child.name),
                icon: Icon(Symbols.delete, color: theme.colorScheme.error),
                tooltip: l10n.profileDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
