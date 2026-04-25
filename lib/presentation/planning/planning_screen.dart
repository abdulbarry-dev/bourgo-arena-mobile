import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/planning/widgets/course_card.dart';
import 'package:flutter/material.dart';

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
            title: const Text('PLANNING DES COURS'),
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
    final categories = ['Tous', 'Fitness', 'Academy', 'Wellness'];

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'FILTRER PAR CATÉGORIE',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              const SizedBox(height: 16),
              ...categories.map(
                (cat) => ListTile(
                  title: Text(cat),
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
    final days = ['LUN', 'MAR', 'MER', 'JEU', 'VEN', 'SAM', 'DIM'];

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: const Border(bottom: BorderSide(color: Colors.white10)),
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
                    color: isSelected ? Colors.black : Colors.white54,
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
      return const Center(child: Text('Aucun cours prévu pour ce jour.'));
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
