import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/viewmodels/family_onboarding_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/family_member_widgets.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _viewModel = FamilyOnboardingViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _viewModel.selectedBirthDate ??
          DateTime.now().subtract(const Duration(days: 365 * 10)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _viewModel.setBirthDate(picked);
      _viewModel.birthDateController.text = DateFormat.yMMMd().format(picked);
    }
  }

  void _onContinue() {
    context.push(
      '/verification-method',
      extra: {
        ...widget.registrationData,
        'familyMembers': _viewModel.members.map((m) => m.toJson()).toList(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
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
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                if (_viewModel.members.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _MembersList(
                      members: _viewModel.members,
                      onRemove: _viewModel.removeMember,
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.all(24.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        FamilyMemberForm(
                          nameController: _viewModel.nameController,
                          birthDateController: _viewModel.birthDateController,
                          selectedGender: _viewModel.selectedGender,
                          onGenderChanged: _viewModel.setGender,
                          onSelectBirthDate: _selectBirthDate,
                          onAdd: _viewModel.addMember,
                          nameError: _viewModel.nameError,
                          genderError: _viewModel.genderError,
                          birthDateError: _viewModel.birthDateError,
                        ),
                        const SizedBox(height: 48),
                        ElevatedButton(
                          onPressed: _onContinue,
                          child: Text(l10n.commonStart),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
        ),
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
                name: member.firstName,
                gender: member.gender,
                onRemove: () => onRemove(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

