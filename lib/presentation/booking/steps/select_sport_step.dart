import 'package:bourgo_arena_mobile/presentation/booking/viewmodels/booking_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/activity_card.dart';
import 'package:flutter/material.dart';

/// Step 1: Select Activity.
class SelectSportStep extends StatelessWidget {
  final BookingViewModel viewModel;

  const SelectSportStep({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: viewModel.activities.length,
      itemBuilder: (context, index) {
        final activity = viewModel.activities[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ActivityCard(
            activity: activity,
            isFullWidth: true,
            onTap: () => viewModel.selectActivity(activity),
          ),
        );
      },
    );
  }
}
