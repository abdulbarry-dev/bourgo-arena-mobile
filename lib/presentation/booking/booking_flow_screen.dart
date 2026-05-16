import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_time_slots_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/cancel_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/make_reservation_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/project_points_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/pricing/get_contextual_price_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/booking/viewmodels/booking_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/booking/steps/payment_step.dart';
import 'package:bourgo_arena_mobile/presentation/booking/steps/select_member_step.dart';
import 'package:bourgo_arena_mobile/presentation/booking/steps/select_sport_step.dart';
import 'package:bourgo_arena_mobile/presentation/booking/steps/select_time_step.dart';
import 'package:bourgo_arena_mobile/presentation/booking/widgets/progress_stepper.dart';
import 'package:flutter/material.dart';

/// Screen wrapper for the multi-step booking process.
class BookingFlowScreen extends StatefulWidget {
  /// Optional activity to start the booking flow with.
  final Activity? initialActivity;

  /// Optional ViewModel for testing purposes.
  final BookingViewModel? viewModel;

  const BookingFlowScreen({super.key, this.initialActivity, this.viewModel});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  late final BookingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel =
        widget.viewModel ??
        BookingViewModel(
          getActivitiesUseCase: locator<GetActivitiesUseCase>(),
          getTimeSlotsUseCase: locator<GetTimeSlotsUseCase>(),
          getUserBookingsUseCase: locator<GetUserBookingsUseCase>(),
          makeReservationUseCase: locator<MakeReservationUseCase>(),
          cancelBookingUseCase: locator<CancelBookingUseCase>(),
          getFamilyMembersUseCase: locator<GetFamilyMembersUseCase>(),
          getUserProfileUseCase: locator<GetUserProfileUseCase>(),
          getContextualPriceUseCase: locator<GetContextualPriceUseCase>(),
          getMemberTierUseCase: locator<GetMemberTierUseCase>(),
          projectPointsUseCase: locator<ProjectPointsUseCase>(),
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
                child: ProgressStepper(
                  currentStep: _viewModel.currentStep,
                  isFamilyFlow: _viewModel.isFamilyAccount,
                ),
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
    if (_viewModel.isFamilyAccount) {
      switch (step) {
        case 0:
          return SelectMemberStep(viewModel: _viewModel);
        case 1:
          return SelectSportStep(viewModel: _viewModel);
        case 2:
          return SelectTimeStep(viewModel: _viewModel);
        case 3:
          return PaymentStep(viewModel: _viewModel);
        default:
          return const SizedBox.shrink();
      }
    }

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
