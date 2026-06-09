import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_course_sessions_use_case.dart';
import 'package:go_router/go_router.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/enroll_in_course_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/planning/widgets/session_schedule_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_error_state.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/celebration_overlay.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/confirm_action_modal.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

/// The course planning/schedule screen with premium UI/UX.
class PlanningScreen extends StatefulWidget {
  final PlanningViewModel? viewModel;
  const PlanningScreen({super.key, this.viewModel});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  late final PlanningViewModel _viewModel;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _viewModel =
        widget.viewModel ??
        PlanningViewModel(
          getCoursesUseCase: locator<GetCoursesUseCase>(),
          getCourseSessionsUseCase: locator<GetCourseSessionsUseCase>(),
          getFamilyMembersUseCase: locator<GetFamilyMembersUseCase>(),
          getMemberTierUseCase: locator<GetMemberTierUseCase>(),
          getUserProfileUseCase: locator<GetUserProfileUseCase>(),
          bookSessionUseCase: locator<BookCourseSessionUseCase>(),
          authStateNotifier: locator<AuthStateNotifier>(),
        );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadPlanning();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _viewModel.loadPlanning,
                  displacement: 20,
                  color: theme.colorScheme.primary,
                  child: _buildBody(context, theme),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    if (_viewModel.isLoading) {
      return _SessionSkeletonLoading(theme: theme);
    }

    if (_viewModel.errorMessage != null) {
      return _buildErrorState(context);
    }

    if (_viewModel.isSubscriptionGate) {
      return _buildSubscriptionGate(context, theme);
    }

    if (!_viewModel.hasSessions) {
      return _buildEmptyState(context);
    }

    return _SessionSchedule(
      key: ValueKey('sessions_${_viewModel.allSessions.length}'),
      viewModel: _viewModel,
      onReserve: _handleReserve,
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

  Widget _buildSubscriptionGate(BuildContext context, ThemeData theme) {
    if (!_viewModel.isAuthenticated) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: PremiumErrorState(
            title: "CONNECTEZ-VOUS",
            message:
                "Connectez-vous pour accéder à votre planning de cours et réserver vos séances.",
            actionLabel: "SE CONNECTER",
            onRetry: () => context.push('/login'),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: EmptyState(
          title: "AUCUNE SÉANCE",
          message:
              "Aucune séance disponible avec votre abonnement actuel. Passez à un abonnement supérieur pour accéder à plus de cours.",
          icon: Symbols.subscriptions,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: EmptyState(
          title: "AUCUNE SÉANCE",
          message:
              "Aucune séance à venir cette semaine. Revenez plus tard pour découvrir le programme.",
          icon: Symbols.calendar_today,
        ),
      ),
    );
  }

  Future<void> _handleReserve(PlanningEntry entry) async {
    if (_isBooking) return;
    _isBooking = true;

    final targetWeekday = entry.dayOfWeek == 0
        ? DateTime.sunday
        : entry.dayOfWeek;
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final nextDate = _findNextMatchingDate(today, targetWeekday);
    final dateStr =
        '${nextDate.year}-${nextDate.month.toString().padLeft(2, '0')}-${nextDate.day.toString().padLeft(2, '0')}';

    final confirmed = await _showBookingModal(context, entry, nextDate);
    if (!confirmed || !mounted) {
      _isBooking = false;
      return;
    }

    final error = await _viewModel.bookSession(
      entry.courseId,
      entry.id,
      dateStr,
    );
    _isBooking = false;
    if (!mounted) return;

    if (error == null) {
      setState(() {});
      CelebrationOverlay.show(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Réservé ${entry.title} le $dateStr à ${entry.startTime}',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<bool> _showBookingModal(
    BuildContext context,
    PlanningEntry entry,
    DateTime nextDate,
  ) async {
    final theme = Theme.of(context);
    final capitalDay = _formatDayName(entry.dayOfWeek);
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    final formattedDate =
        '$capitalDay ${nextDate.day} ${months[nextDate.month - 1]} ${nextDate.year}';

    return await ConfirmActionModal.show(
          context: context,
          icon: Symbols.event,
          title: 'RÉSERVER',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                entry.title.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                  fontFamily: AppConstants.displayFontFamily,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                formattedDate,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                entry.formattedTime,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.7,
                  ),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  String _formatDayName(int dayOfWeek) {
    const raw = [
      'Dimanche',
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
    ];
    return raw[dayOfWeek];
  }

  DateTime _findNextMatchingDate(DateTime from, int targetWeekday) {
    var date = from;
    while (date.weekday != targetWeekday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
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

class _SessionSchedule extends StatelessWidget {
  final PlanningViewModel viewModel;
  final void Function(PlanningEntry) onReserve;

  const _SessionSchedule({
    super.key,
    required this.viewModel,
    required this.onReserve,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = viewModel.availableDays;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      itemCount: days.length,
      itemBuilder: (context, dayIndex) {
        final day = days[dayIndex];
        final sessions = viewModel.sessionsByDay[day]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DayHeader(
              dayName: PlanningViewModel.dayNames[day] ?? '',
              theme: theme,
            ).animate().fade(duration: 300.ms).slideX(begin: -0.05),
            const SizedBox(height: 10),
            ...List.generate(sessions.length, (i) {
              final entry = sessions[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child:
                    SessionScheduleCard(
                          entry: entry,
                          isBooked: entry.isBooked,
                          onTap: () => context.push(
                            '/courses/${entry.courseId}',
                            extra: entry.source,
                          ),
                          onReserve: () => onReserve(entry),
                        )
                        .animate(delay: (dayIndex * 80 + i * 50).ms)
                        .fade(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
              );
            }),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

class _DayHeader extends StatelessWidget {
  final String dayName;
  final ThemeData theme;

  const _DayHeader({required this.dayName, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          dayName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontFamily: GoogleFonts.lexend().fontFamily,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _SessionSkeletonLoading extends StatelessWidget {
  final ThemeData theme;

  const _SessionSkeletonLoading({required this.theme});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      children: [
        for (int d = 0; d < 3; d++) ...[
          _DayHeader(
            dayName: d == 0
                ? 'DIMANCHE'
                : d == 1
                ? 'LUNDI'
                : 'MARDI',
            theme: theme,
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < 3; i++)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: _SessionSkeletonCard(),
            ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _SessionSkeletonCard extends StatelessWidget {
  const _SessionSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
      highlightColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
      child: Container(
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: appColors.bgBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 88, color: Colors.white),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 160,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 90,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
