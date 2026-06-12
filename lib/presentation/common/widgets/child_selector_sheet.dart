import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_children_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

const kAddChildSentinel = '__add_child__';

/// Returns `null` for self, a child's `id` for a specific child,
/// or [kAddChildSentinel] to add a new child.
Future<String?> showChildSelectorSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ChildSelectorSheet(),
  );
}

class _ChildSelectorSheet extends StatefulWidget {
  const _ChildSelectorSheet();

  @override
  State<_ChildSelectorSheet> createState() => _ChildSelectorSheetState();
}

class _ChildSelectorSheetState extends State<_ChildSelectorSheet> {
  final GetChildrenUseCase _getChildren = locator<GetChildrenUseCase>();
  List<ChildProfile>? _children;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await _getChildren.execute();
    if (!mounted) return;
    result.when(
      success: (children) => setState(() {
        _children = children;
        _isLoading = false;
      }),
      failure: (_) => setState(() => _isLoading = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final appColors = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.lg + bottomInset,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: appColors.bgBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: spacing.lg),
          Text(
            AppLocalizations.of(context)!.childSelectorTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.xl),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            _OptionTile(
              icon: Symbols.person,
              title: l10n.commonMe,
              subtitle: AppLocalizations.of(context)!.childSelectorSelfDesc,
              onTap: () => Navigator.pop(context, null),
            ),
            if (_children != null) ...[
              if (_children!.isEmpty)
                _OptionTile(
                  icon: Symbols.person,
                  title: AppLocalizations.of(
                    context,
                  )!.childSelectorNoChildrenTitle,
                  subtitle: AppLocalizations.of(
                    context,
                  )!.childSelectorNoChildrenDesc,
                  onTap: () {},
                )
              else ...[
                ..._children!.map(
                  (child) => Padding(
                    padding: EdgeInsets.only(top: spacing.sm),
                    child: _OptionTile(
                      icon: child.gender?.toLowerCase() == 'female'
                          ? Symbols.girl
                          : Symbols.boy,
                      title: child.name,
                      subtitle: null,
                      onTap: () => Navigator.pop(context, child.id),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: appColors.bgElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: appColors.bgBorder),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                child: Icon(icon, size: 20, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Symbols.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
