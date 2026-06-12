import 'dart:async';

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/viewmodels/family_onboarding_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_background.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/family_member_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Screen for adding family members during registration.
class FamilyOnboardingScreen extends StatefulWidget {
  /// Registration data passed from previous steps.
  final Map<String, dynamic> registrationData;

  /// Creates a [FamilyOnboardingScreen].
  const FamilyOnboardingScreen({super.key, required this.registrationData});

  @override
  State<FamilyOnboardingScreen> createState() => _FamilyOnboardingScreenState();
}

class _FamilyOnboardingScreenState extends State<FamilyOnboardingScreen> {
  late final FamilyOnboardingViewModel _viewModel;
  late final SessionRepository _sessionRepository;

  @override
  void initState() {
    super.initState();
    _sessionRepository = locator<SessionRepository>();
    _viewModel = FamilyOnboardingViewModel();
    _viewModel.addListener(_persistDraft);
    _viewModel.firstNameController.addListener(_persistDraft);
    _viewModel.lastNameController.addListener(_persistDraft);
    _viewModel.birthDateController.addListener(_persistDraft);
    _restoreDraft();
    _persistDraft();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_persistDraft);
    _viewModel.firstNameController.removeListener(_persistDraft);
    _viewModel.lastNameController.removeListener(_persistDraft);
    _viewModel.birthDateController.removeListener(_persistDraft);
    _viewModel.dispose();
    super.dispose();
  }

  void _restoreDraft() {
    final draft = widget.registrationData;
    final storedMembers = draft['familyMembers'];
    if (storedMembers is List<ChildProfile>) {
      _viewModel.setMembers(storedMembers);
    } else if (storedMembers is List) {
      final members = storedMembers.whereType<ChildProfile>().toList(
        growable: false,
      );
      if (members.isNotEmpty) {
        _viewModel.setMembers(members);
      }
    }

    _viewModel.firstNameController.text =
        draft['pendingFirstName'] as String? ?? '';
    _viewModel.lastNameController.text =
        draft['pendingLastName'] as String? ?? '';

    final pendingBirthDate = draft['pendingBirthDate'];
    if (pendingBirthDate is DateTime) {
      _viewModel.setBirthDate(pendingBirthDate);
      _viewModel.birthDateController.text = DateFormat.yMMMd().format(
        pendingBirthDate,
      );
    }

    _viewModel.setGender(draft['pendingGender'] as String?);
  }

  void _persistDraft() {
    unawaited(
      _sessionRepository.saveRegistrationDraft({
        'route': '/family-onboarding',
        'extra': {
          ...widget.registrationData,
          'familyMembers': _viewModel.members,
          'pendingFirstName': _viewModel.firstNameController.text,
          'pendingLastName': _viewModel.lastNameController.text,
          'pendingBirthDate': _viewModel.selectedBirthDate,
          'pendingGender': _viewModel.selectedGender,
        },
      }),
    );
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _viewModel.selectedBirthDate ??
          DateTime.now().subtract(const Duration(days: 365 * 10)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _viewModel.setBirthDate(picked);
      _viewModel.birthDateController.text = DateFormat.yMMMd().format(picked);
      _persistDraft();
    }
  }

  void _onContinue() {
    AppHaptics.light();
    _persistDraft();
    context.push(
      '/verification-method',
      extra: {...widget.registrationData, 'familyMembers': _viewModel.members},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: _onContinue,
              child: Text(
                l10n.authDoItLater,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AuthHeader(
                                title: l10n.authFamilyOnboardingTitle,
                                subtitle: l10n.authFamilyOnboardingSubtitle,
                                subtitleColor:
                                    theme.colorScheme.onSurfaceVariant,
                              )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(
                                begin: 0.1,
                                end: 0,
                                curve: Curves.easeOutQuad,
                              ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.topCenter,
                      child: _viewModel.members.isNotEmpty
                          ? _MembersList(
                              members: _viewModel.members,
                              onRemove: _viewModel.removeMember,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 24.0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children:
                            [
                                  FamilyMemberForm(
                                    firstNameController:
                                        _viewModel.firstNameController,
                                    lastNameController:
                                        _viewModel.lastNameController,
                                    birthDateController:
                                        _viewModel.birthDateController,
                                    selectedGender: _viewModel.selectedGender,
                                    onGenderChanged: _viewModel.setGender,
                                    onSelectBirthDate: _selectBirthDate,
                                    onAdd: () {
                                      AppHaptics.selection();
                                      _viewModel.addMember();
                                    },
                                    firstNameError: _viewModel.hasFirstNameError
                                        ? l10n.commonRequiredField
                                        : null,
                                    lastNameError: _viewModel.hasLastNameError
                                        ? l10n.commonRequiredField
                                        : null,
                                    genderError: _viewModel.hasGenderError
                                        ? l10n.commonRequiredField
                                        : null,
                                    birthDateError: _viewModel.hasBirthDateError
                                        ? l10n.commonRequiredField
                                        : null,
                                  ),
                                  const SizedBox(height: 48),
                                  FilledButton(
                                    onPressed: _onContinue,
                                    style: FilledButton.styleFrom(
                                      minimumSize: const Size(
                                        double.infinity,
                                        56,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      l10n.commonStart,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ]
                                .animate(interval: 50.ms)
                                .fadeIn(duration: 350.ms)
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  curve: Curves.easeOutQuad,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MembersList extends StatelessWidget {
  final List members;
  final Function(int) onRemove;

  const _MembersList({required this.members, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                l10n.authAddedMembers.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: members.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final member = members[index];
              return FamilyMemberCard(
                    name: member.name,
                    gender: member.gender,
                    onRemove: () {
                      AppHaptics.selection();
                      onRemove(index);
                    },
                  )
                  .animate(delay: (index.clamp(0, 8) * 50).ms)
                  .fadeIn(duration: 350.ms)
                  .slideY(
                    begin: 0.08,
                    end: 0,
                    curve: Curves.easeOutCubic,
                  );
            },
          ),
        ),
      ],
    );
  }
}
