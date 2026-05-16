import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/planning/widgets/course_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:bourgo_arena_mobile/presentation/activities/widgets/reservation_card.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The course planning/schedule screen.
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
          getUserBookingsUseCase: locator<GetUserBookingsUseCase>(),
          getFamilyMembersUseCase: locator<GetFamilyMembersUseCase>(),
          getMemberTierUseCase: locator<GetMemberTierUseCase>(),
          getUserProfileUseCase: locator<GetUserProfileUseCase>(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.planningTitle),
            backgroundColor: theme.colorScheme.surface,
          ),
          body: Column(
            children: [
              _DaySelector(viewModel: _viewModel),
              _PlanningControls(viewModel: _viewModel),
              Expanded(
                child: _viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _viewModel.errorMessage != null
                    ? Center(
                        child: Text(
                          _viewModel.errorMessage!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      )
                    : _UnifiedList(viewModel: _viewModel),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DaySelector extends StatelessWidget {
  final PlanningViewModel viewModel;

  const _DaySelector({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = [
      AppLocalizations.of(context)!.commonMon,
      AppLocalizations.of(context)!.commonTue,
      AppLocalizations.of(context)!.commonWed,
      AppLocalizations.of(context)!.commonThu,
      AppLocalizations.of(context)!.commonFri,
      AppLocalizations.of(context)!.commonSat,
      AppLocalizations.of(context)!.commonSun,
    ];

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final dayIndex = index + 1;
          final isSelected = viewModel.selectedDay == dayIndex;

          return GestureDetector(
            onTap: () => viewModel.selectDay(dayIndex),
            child: Container(
              width: 50,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  days[index],
                  style: TextStyle(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PlanningControls extends StatelessWidget {
  final PlanningViewModel viewModel;

  const _PlanningControls({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          if (viewModel.familyMembers.length > 1)
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: viewModel.selectedMember?.id,
                isExpanded: true,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                items: viewModel.familyMembers
                    .map(
                      (m) => DropdownMenuItem(
                        value: m.id,
                        child: Text(m.isPrimary ? '${m.name} (Me)' : m.name),
                      ),
                    )
                    .toList(),
                onChanged: (id) {
                  if (id == null) return;
                  final member = viewModel.familyMembers.firstWhere(
                    (m) => m.id == id,
                    orElse: () => viewModel.familyMembers.first,
                  );
                  viewModel.selectMember(member);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _UnifiedList extends StatelessWidget {
  final PlanningViewModel viewModel;

  const _UnifiedList({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final entries = viewModel.unified;

    if (entries.isEmpty) {
      return EmptyState(
        title: AppLocalizations.of(context)!.planningNoCourses,
        message: AppLocalizations.of(context)!.planningNoCoursesSubtitle,
        icon: Symbols.calendar_today,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final child = switch (entry.type) {
          PlanningEntryType.course => CourseCard(
            course: entry.source as Course,
          ),
          PlanningEntryType.reservation => ReservationCard(
            reservation: entry.source as Reservation,
          ),
        };
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: child,
        );
      },
    );
  }
}
