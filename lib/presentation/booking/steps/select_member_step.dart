import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/booking/viewmodels/booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Step 1 (Family only): Select which family member this booking is for.
class SelectMemberStep extends StatelessWidget {
  final BookingViewModel viewModel;

  const SelectMemberStep({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final members = viewModel.familyMembers;

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: members.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final member = members[index];
              final isSelected = viewModel.selectedMember?.id == member.id;

              return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      AppHaptics.selection();
                      viewModel.selectMember(member);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary.withValues(alpha: 0.06)
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(
                                  alpha: 0.12,
                                ),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: member.avatarUrl != null
                                ? NetworkImage(member.avatarUrl!)
                                : null,
                            child: member.avatarUrl == null
                                ? const Icon(Symbols.person, size: 20)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.isPrimary
                                      ? '${member.name} (${AppLocalizations.of(context)!.commonMe})'
                                      : member.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.bookingMemberSelectSubtitle,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                                  Symbols.check_circle,
                                  color: theme.colorScheme.primary,
                                  size: 20,
                                )
                                .animate()
                                .scale(
                                  duration: 220.ms,
                                  curve: Curves.easeOutBack,
                                  begin: const Offset(0.6, 0.6),
                                  end: const Offset(1, 1),
                                )
                                .fadeIn(duration: 160.ms),
                        ],
                      ),
                    ),
                  )
                  .animate(delay: (index.clamp(0, 8) * 50).ms)
                  .fadeIn(duration: 350.ms)
                  .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: ElevatedButton(
              onPressed: viewModel.selectedMember == null
                  ? null
                  : () {
                      AppHaptics.light();
                      viewModel.nextStep();
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: Text(AppLocalizations.of(context)!.commonContinue),
            ),
          ),
        ),
      ],
    );
  }
}
