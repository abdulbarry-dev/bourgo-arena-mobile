import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/planning/widgets/course_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The course planning/schedule screen.
class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  late final PlanningViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PlanningViewModel(dataService: DataService());
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
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showCategoryFilter(context),
              ),
            ],
          ),
          body: Column(
            children: [
              _DaySelector(viewModel: _viewModel),
              Expanded(
                child: _viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _CourseList(viewModel: _viewModel),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryFilter(BuildContext context) {
    final theme = Theme.of(context);
    final categories = [
      AppConstants.planningCategoryAll,
      AppConstants.planningCategoryFitness,
      AppConstants.planningCategoryAcademy,
      AppConstants.planningCategoryWellness,
    ];

    final Map<String, String> categoryLabels = {
      AppConstants.planningCategoryAll: AppLocalizations.of(
        context,
      )!.planningCategoryAll,
      AppConstants.planningCategoryFitness: AppLocalizations.of(
        context,
      )!.planningCategoryFitness,
      AppConstants.planningCategoryAcademy: AppLocalizations.of(
        context,
      )!.planningCategoryAcademy,
      AppConstants.planningCategoryWellness: AppLocalizations.of(
        context,
      )!.planningCategoryWellness,
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.planningFilterTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              ...categories.map(
                (cat) => ListTile(
                  title: Text(categoryLabels[cat] ?? cat),
                  onTap: () {
                    _viewModel.selectCategory(cat);
                    Navigator.pop(context);
                  },
                  trailing: _viewModel.selectedCategory == cat
                      ? Icon(Icons.check, color: theme.colorScheme.primary)
                      : null,
                ),
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

class _CourseList extends StatelessWidget {
  final PlanningViewModel viewModel;

  const _CourseList({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final courses = viewModel.courses;

    if (courses.isEmpty) {
      return EmptyState(
        title: AppLocalizations.of(context)!.planningNoCourses,
        message: AppLocalizations.of(context)!.planningNoCoursesSubtitle,
        icon: Symbols.calendar_today,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CourseCard(course: courses[index]),
        );
      },
    );
  }
}
