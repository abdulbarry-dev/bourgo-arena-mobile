import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:go_router/go_router.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/auth_utils.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_course_sessions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/enroll_in_course_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/planning/widgets/course_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_error_state.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:google_fonts/google_fonts.dart';

/// The course planning/schedule screen with premium UI/UX.
class PlanningScreen extends StatefulWidget {
  final PlanningViewModel? viewModel;
  const PlanningScreen({super.key, this.viewModel});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  late final PlanningViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel =
        widget.viewModel ??
        PlanningViewModel(
          getCoursesUseCase: locator<GetCoursesUseCase>(),
          getFamilyMembersUseCase: locator<GetFamilyMembersUseCase>(),
          getMemberTierUseCase: locator<GetMemberTierUseCase>(),
          getUserProfileUseCase: locator<GetUserProfileUseCase>(),
          getActiveSubscriptionsUseCase:
              locator<GetActiveSubscriptionsUseCase>(),
          getCourseSessionsUseCase: locator<GetCourseSessionsUseCase>(),
          enrollInCourseUseCase: locator<EnrollInCourseUseCase>(),
          authStateNotifier: locator<AuthStateNotifier>(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              AppLocalizations.of(context)!.planningTitle.toUpperCase(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontFamily: AppConstants.displayFontFamily,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            actions: [
              if (_viewModel.familyMembers.length > 1)
                _MemberSelector(viewModel: _viewModel),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              _DaySelector(viewModel: _viewModel),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _viewModel.loadPlanning,
                  displacement: 20,
                  color: theme.colorScheme.primary,
                  child: _viewModel.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : _viewModel.errorMessage != null
                      ? _buildErrorState(context)
                      : _UnifiedList(viewModel: _viewModel),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: PremiumErrorState(
          title: "ERREUR DE PLANNING",
          message:
              "Impossible de récupérer le programme des cours. Veuillez vérifier votre connexion.",
          actionLabel: "Réessayer",
          onRetry: _viewModel.loadPlanning,
        ),
      ),
    );
  }
}

class _MemberSelector extends StatelessWidget {
  final PlanningViewModel viewModel;

  const _MemberSelector({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      initialValue: viewModel.selectedMember?.id,
      onSelected: (id) {
        final member = viewModel.familyMembers.firstWhere((m) => m.id == id);
        viewModel.selectMember(member);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              viewModel.selectedMember?.name ?? "Moi",
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => viewModel.familyMembers.map((m) {
        return PopupMenuItem(
          value: m.id,
          child: Text(
            m.isPrimary ? '${m.name} (Moi)' : m.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      }).toList(),
    );
  }
}

class _DaySelector extends StatelessWidget {
  final PlanningViewModel viewModel;

  const _DaySelector({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = AppLocalizations.of(context)!;

    final days = [
      l10n.commonMon,
      l10n.commonTue,
      l10n.commonWed,
      l10n.commonThu,
      l10n.commonFri,
      l10n.commonSat,
      l10n.commonSun,
    ];

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final dayIndex = index + 1;
          final isSelected = viewModel.selectedDay == dayIndex;

          return GestureDetector(
                onTap: () => viewModel.selectDay(dayIndex),
                child: Container(
                  width: 54,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.4,
                          ),
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.05,
                            ),
                          ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        days[index].toUpperCase(),
                        style: TextStyle(
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                ),
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
              .animate(delay: (index * 40).ms)
              .fade(duration: 300.ms)
              .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack);
        },
      ),
    );
  }
}

class _UnifiedList extends StatelessWidget {
  final PlanningViewModel viewModel;

  const _UnifiedList({required this.viewModel});

  void _showQuickAssignSheet(BuildContext context, Course course) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final appColors = theme.extension<AppColors>()!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(spacing.lg).copyWith(
            bottom: MediaQuery.of(context).padding.bottom + spacing.lg,
          ),
          decoration: BoxDecoration(
            color: appColors.bgElevated,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 32),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                course.name.toUpperCase(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontFamily: AppConstants.displayFontFamily,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Symbols.schedule,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${course.startTime} - ${course.endTime}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.lexend().fontFamily,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (ensureAuthenticated(context)) {
                    final success = await viewModel.enrollInCourse(course.id);
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Successfully assigned to course!',
                          ),
                          backgroundColor: theme.colorScheme.primary,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  minimumSize: const Size(double.infinity, 60),
                  elevation: 8,
                  shadowColor: theme.colorScheme.primary.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'RESERVER MA PLACE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/courses/${course.id}', extra: course);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  side: BorderSide(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'VOIR LES DÉTAILS',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = viewModel.unified;

    if (entries.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: EmptyState(
            title: AppLocalizations.of(context)!.planningNoCourses,
            message: AppLocalizations.of(context)!.planningNoCoursesSubtitle,
            icon: Symbols.calendar_today,
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final child = CourseCard(
          course: entry.source as Course,
          onTap: () => _showQuickAssignSheet(context, entry.source as Course),
        );
        return Padding(padding: const EdgeInsets.only(bottom: 16), child: child)
            .animate(delay: (index * 50).ms)
            .fade(duration: 400.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
      },
    );
  }
}
