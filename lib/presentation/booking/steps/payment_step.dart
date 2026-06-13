import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/pay_with_loyalty_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/booking/viewmodels/booking_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/animated_loyalty_balance.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/confirm_action_modal.dart';
import 'package:bourgo_arena_mobile/presentation/payment/payment_webview_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// States for the Konnect payment sub-flow within [PaymentStep].
enum _KonnectPaymentState {
  /// Showing the summary and payment method selector.
  idle,

  /// Calling makeReservation on the server.
  processingReservation,

  /// WebView is open — payment in progress.
  openingGateway,

  /// Verifying payment status with the server.
  verifying,

  /// Payment confirmed — show success.
  success,

  /// Payment failed or could not be verified.
  failed,
}

/// Step 3: Payment and Confirmation Summary.
class PaymentStep extends StatefulWidget {
  /// The view model driving the booking flow.
  final BookingViewModel viewModel;

  /// Creates a [PaymentStep].
  const PaymentStep({super.key, required this.viewModel});

  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> {
  _KonnectPaymentState _konnectState = _KonnectPaymentState.idle;
  String? _errorMessage;
  String? _pendingReservationId;
  int? _pendingDepositPaymentId;
  bool _isProcessing = false;

  void _navigateToSuccess() {
    if (!mounted) return;
    setState(() {
      _konnectState = _KonnectPaymentState.idle;
    });
    context.push('/booking-success', extra: widget.viewModel.selectedActivity);
  }

  Future<void> _handlePayment() async {
    if (_isProcessing) return;
    _isProcessing = true;

    setState(() {
      _konnectState = _KonnectPaymentState.processingReservation;
      _errorMessage = null;
    });

    final success = await widget.viewModel.makeReservation();
    if (!mounted) {
      _isProcessing = false;
      return;
    }

    if (!success) {
      setState(() {
        _isProcessing = false;
        _konnectState = _KonnectPaymentState.failed;
        _errorMessage =
            widget.viewModel.errorMessage ??
            AppLocalizations.of(context)!.paymentErrorGeneric;
      });
      return;
    }

    final requiresDeposit = widget.viewModel.requiresDeposit;
    if (!requiresDeposit) {
      _isProcessing = false;
      _navigateToSuccess();
      return;
    }

    final reservationId = widget.viewModel.createdReservationId;
    final isLoyalty =
        widget.viewModel.paymentMethod == AppConstants.paymentMethodWalletId;

    if (isLoyalty) {
      final confirmed = await ConfirmActionModal.show(
        context: context,
        icon: Symbols.stars,
        title: AppLocalizations.of(context)!.paymentPointsTitle,
        message: AppLocalizations.of(context)!.paymentPointsDesc,
        content: Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const AnimatedLoyaltyBalance(isVisible: true),
        ),
        confirmLabel: AppLocalizations.of(context)!.actionPayNow,
      );
      if (confirmed != true) {
        setState(() {
          _isProcessing = false;
          _konnectState = _KonnectPaymentState.idle;
        });
        return;
      }
      await _handleLoyaltyPayment(reservationId);
    } else {
      await _openKonnectGateway(
        reservationId: reservationId,
        depositUrl: widget.viewModel.depositUrl,
        depositPaymentId: widget.viewModel.depositPaymentId,
      );
    }
  }

  /// Pays using loyalty points — no WebView needed.
  Future<void> _handleLoyaltyPayment(String? reservationId) async {
    if (reservationId == null) {
      setState(() {
        _isProcessing = false;
        _konnectState = _KonnectPaymentState.failed;
        _errorMessage = AppLocalizations.of(context)!.paymentErrorMissingId;
      });
      return;
    }

    final parsedId = int.tryParse(reservationId);
    if (parsedId == null) {
      setState(() {
        _isProcessing = false;
        _konnectState = _KonnectPaymentState.failed;
        _errorMessage = AppLocalizations.of(context)!.paymentErrorInvalidId;
      });
      return;
    }

    setState(() => _konnectState = _KonnectPaymentState.verifying);

    final useCase = locator<PayWithLoyaltyUseCase>();
    final result = await useCase(type: 'reservation', id: parsedId);

    if (!mounted) {
      _isProcessing = false;
      return;
    }

    result.fold(
      onSuccess: (_) {
        _isProcessing = false;
        _navigateToSuccess();
      },
      onFailure: (failure) {
        setState(() {
          _isProcessing = false;
          _konnectState = _KonnectPaymentState.failed;
          _errorMessage = failure.message;
        });
      },
    );
  }

  /// Opens the Konnect gateway in a full-screen in-app WebView (or redirects on Web).
  Future<void> _openKonnectGateway({
    required String? reservationId,
    required String? depositUrl,
    required int? depositPaymentId,
  }) async {
    if (depositUrl == null || reservationId == null) {
      setState(() {
        _isProcessing = false;
        _konnectState = _KonnectPaymentState.failed;
        _errorMessage = AppLocalizations.of(context)!.paymentErrorNoUrl;
      });
      return;
    }

    _pendingReservationId = reservationId;
    _pendingDepositPaymentId = depositPaymentId;

    if (kIsWeb) {
      final uri = Uri.tryParse(depositUrl);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, webOnlyWindowName: '_self');
      } else if (mounted) {
        setState(() {
          _isProcessing = false;
          _konnectState = _KonnectPaymentState.failed;
          _errorMessage = AppLocalizations.of(context)!.paymentErrorCannotOpen;
        });
      }
      return;
    }

    setState(() => _konnectState = _KonnectPaymentState.openingGateway);

    final result = await Navigator.of(context).push<PaymentWebViewResult>(
      MaterialPageRoute(
        builder: (_) => PaymentWebViewScreen(paymentUrl: depositUrl),
      ),
    );

    if (!mounted) {
      _isProcessing = false;
      return;
    }

    switch (result) {
      case PaymentWebViewResult.success:
        // Gateway confirmed payment via redirect — verify with server.
        await _verifyPayment();
      case PaymentWebViewResult.failure:
        // Gateway explicitly signalled failure.
        setState(() {
          _isProcessing = false;
          _konnectState = _KonnectPaymentState.failed;
          _errorMessage = AppLocalizations.of(context)!.paymentErrorGeneric;
        });
      case PaymentWebViewResult.dismissed:
      case null:
        // User closed the WebView without completing payment — go back
        // to the summary so they can retry. No verification needed.
        setState(() {
          _isProcessing = false;
          _konnectState = _KonnectPaymentState.idle;
          _errorMessage = null;
        });
    }
  }

  /// Calls the server to confirm the payment status.
  Future<void> _verifyPayment() async {
    setState(() => _konnectState = _KonnectPaymentState.verifying);

    final repository = locator<ReservationRepository>();
    final verifyResult = await repository.verifyPayment(
      _pendingReservationId!,
      _pendingDepositPaymentId?.toString() ?? '',
    );

    if (!mounted) {
      _isProcessing = false;
      return;
    }

    verifyResult.fold(
      onSuccess: (status) {
        if (status == 'paid' || status == 'completed') {
          _isProcessing = false;
          _navigateToSuccess();
        } else {
          setState(() {
            _isProcessing = false;
            _konnectState = _KonnectPaymentState.idle;
            _errorMessage = AppLocalizations.of(
              context,
            )!.paymentErrorUnconfirmed;
          });
        }
      },
      onFailure: (failure) {
        setState(() {
          _isProcessing = false;
          _konnectState = _KonnectPaymentState.failed;
          _errorMessage = failure.message;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_konnectState) {
      case _KonnectPaymentState.processingReservation:
        return _LoadingView(
          message: AppLocalizations.of(context)!.paymentCreatingReservation,
        );
      case _KonnectPaymentState.openingGateway:
        return _LoadingView(
          message: AppLocalizations.of(context)!.paymentOpeningGateway,
        );
      case _KonnectPaymentState.verifying:
        return _LoadingView(
          message: AppLocalizations.of(context)!.paymentVerifying,
        );
      case _KonnectPaymentState.success:
        return const SizedBox.shrink();
      case _KonnectPaymentState.failed:
        return _FailedView(
          message:
              _errorMessage ??
              AppLocalizations.of(context)!.paymentErrorGeneric,
          onRetry: () => setState(() {
            _konnectState = _KonnectPaymentState.idle;
            _errorMessage = null;
          }),
        );
      case _KonnectPaymentState.idle:
        return _IdleView(
          viewModel: widget.viewModel,
          onPay: _handlePayment,
          errorMessage: _errorMessage,
        );
    }
  }
}

/// Full-screen loading state — shown during server calls and WebView open.
class _LoadingView extends StatelessWidget {
  final String message;

  const _LoadingView({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-screen failure state — shows error message with a retry button.
class _FailedView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _FailedView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Symbols.error, size: 100, color: theme.colorScheme.error),
          const SizedBox(height: 32),
          Text(
            AppLocalizations.of(context)!.paymentFailedTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontFamily: AppConstants.displayFontFamily,
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.error,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.onSurface,
              minimumSize: const Size(double.infinity, 56),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.paymentTryAgain,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The default idle view — summary card + payment method selector + pay button.
class _IdleView extends StatelessWidget {
  final BookingViewModel viewModel;
  final VoidCallback onPay;
  final String? errorMessage;

  const _IdleView({
    required this.viewModel,
    required this.onPay,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(title: l10n.bookingSummaryTitle),
                _SummaryCard(viewModel: viewModel),
                const SizedBox(height: 32),
                _SectionTitle(title: l10n.bookingPaymentTitle),
                _PaymentMethodSelector(viewModel: viewModel),
                if (errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _ErrorBanner(message: errorMessage!),
                ],
              ],
            ),
          ),
        ),
        _BottomPayButton(
          onPressed: onPay,
          price: viewModel.depositAmount,
          isLoading: false,
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Symbols.error,
            size: 18,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final BookingViewModel viewModel;

  const _SummaryCard({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activity = viewModel.selectedActivity;
    final price = viewModel.priceToPay;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(50)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.primary.withAlpha(10),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withAlpha(30),
                ),
                child: Icon(
                  _getIcon(activity?.icon ?? ''),
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${price.toStringAsFixed(2)} ${activity?.currency ?? ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      viewModel.isPricingLoading
                          ? '${activity?.category ?? ''} • …'
                          : (activity?.category ?? ''),
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          _SummaryRow(
            icon: Symbols.calendar_month,
            label: AppLocalizations.of(context)!.bookingDate,
            value: DateFormat(
              'dd MMMM yyyy',
              Localizations.localeOf(context).toString(),
            ).format(viewModel.selectedDate),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            icon: Symbols.schedule,
            label: AppLocalizations.of(context)!.bookingTime,
            value: viewModel.selectedSlot?.time ?? '',
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            icon: Symbols.hourglass_bottom,
            label: AppLocalizations.of(context)!.bookingDuration,
            value: activity?.id == 'padel-1'
                ? AppLocalizations.of(context)!.bookingDurationPadel
                : AppLocalizations.of(context)!.bookingDurationStandard,
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            icon: Symbols.stars,
            label: AppLocalizations.of(context)!.bookingPointsToEarned,
            value:
                '${viewModel.projectedPoints} ${AppLocalizations.of(context)!.commonPointsShort}',
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            icon: Symbols.payments,
            label: AppLocalizations.of(context)!.paymentDepositRequired,
            value:
                '${viewModel.depositAmount.toStringAsFixed(2)} ${activity?.currency ?? ''}',
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'sports_tennis':
        return Icons.sports_tennis;
      case 'sports_basketball':
        return Icons.sports_basketball;
      case 'fitness_center':
        return Icons.fitness_center;
      default:
        return Icons.sports;
    }
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodSelector extends StatelessWidget {
  final BookingViewModel viewModel;

  const _PaymentMethodSelector({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PaymentOption(
          icon: Symbols.credit_card,
          label: AppLocalizations.of(context)!.bookingMethodCard,
          subtitle: AppLocalizations.of(context)!.paymentMethodCardDesc,
          isSelected:
              viewModel.paymentMethod == AppConstants.paymentMethodCardId,
          isLoyaltyOption: false,
          onTap: () =>
              viewModel.setPaymentMethod(AppConstants.paymentMethodCardId),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          icon: Symbols.stars,
          label: AppLocalizations.of(context)!.bookingMethodWallet,
          subtitle: AppLocalizations.of(context)!.paymentMethodPointsDesc,
          isSelected:
              viewModel.paymentMethod == AppConstants.paymentMethodWalletId,
          isLoyaltyOption: true,
          onTap: () =>
              viewModel.setPaymentMethod(AppConstants.paymentMethodWalletId),
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final bool isLoyaltyOption;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.isLoyaltyOption = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.06)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.12),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.12)
                    : theme.colorScheme.surfaceContainerHighest,
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (isLoyaltyOption)
                    AnimatedLoyaltyBalance(isVisible: isSelected),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (isSelected)
              Icon(
                Symbols.check_circle,
                color: theme.colorScheme.primary,
                size: 22,
              )
            else
              Icon(
                Icons.radio_button_unchecked,
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomPayButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double price;
  final bool isLoading;

  const _BottomPayButton({
    required this.onPressed,
    required this.price,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            disabledBackgroundColor: theme.colorScheme.primary.withValues(
              alpha: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  '${AppLocalizations.of(context)!.bookingPay} 10% Deposit — ${price.toStringAsFixed(2)} ${AppLocalizations.of(context)!.bookingCurrency}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
        ),
      ),
    );
  }
}
