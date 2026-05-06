import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/data/services/activity_service.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/booking/viewmodels/booking_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/booking/steps/payment_step.dart';
import 'package:bourgo_arena_mobile/presentation/booking/steps/select_sport_step.dart';
import 'package:bourgo_arena_mobile/presentation/booking/steps/select_time_step.dart';
import 'package:bourgo_arena_mobile/presentation/booking/widgets/progress_stepper.dart';
import 'package:flutter/material.dart';

/// Screen wrapper for the multi-step booking process.
class BookingFlowScreen extends StatefulWidget {
  /// Optional activity to start the booking flow with.
  final Activity? initialActivity;
  final ActivityService activityService;

  const BookingFlowScreen({
    super.key,
    this.initialActivity,
    required this.activityService,
  });

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  late final BookingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BookingViewModel(
      activityService: widget.activityService,
      initialActivity: widget.initialActivity,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,
            title: Text(AppLocalizations.of(context)!.bookingTitle),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (_viewModel.currentStep > 0 &&
                    widget.initialActivity == null) {
                  _viewModel.previousStep();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ProgressStepper(currentStep: _viewModel.currentStep),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildStep(_viewModel.currentStep),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return SelectSportStep(viewModel: _viewModel);
      case 1:
        return SelectTimeStep(viewModel: _viewModel);
      case 2:
        return PaymentStep(viewModel: _viewModel);
      default:
        return const SizedBox.shrink();
    }
  }
}
