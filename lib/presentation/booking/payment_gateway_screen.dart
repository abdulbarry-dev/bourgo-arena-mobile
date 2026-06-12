import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:bourgo_arena_mobile/presentation/booking/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// Screen handling the full payment flow for a reservation.
///
/// Shows the gateway selector → initiates payment → opens browser → verifies
/// on return.
class PaymentGatewayScreen extends StatefulWidget {
  /// The reservation ID to pay for.
  final String reservationId;

  /// The deposit amount to pay (optional).
  final double? amount;

  /// Creates a [PaymentGatewayScreen].
  const PaymentGatewayScreen({
    super.key,
    required this.reservationId,
    this.amount,
  });

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen>
    with WidgetsBindingObserver {
  PaymentViewModel? _viewModel;
  bool _didReturnFromBrowser = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startPayment());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _didReturnFromBrowser &&
        _viewModel != null) {
      _didReturnFromBrowser = false;
      _viewModel!.verifyPayment();
    }
  }

  void _initViewModel() {
    _viewModel?.dispose();
    _viewModel = PaymentViewModel(
      reservationRepository: locator<ReservationRepository>(),
      reservationId: widget.reservationId,
      amount: widget.amount,
    );
    setState(() {});
  }

  Future<void> _startPayment() async {
    _initViewModel();
    await _viewModel!.initiatePayment();

    final url = _viewModel!.paymentUrl;
    if (url == null) {
      if (_viewModel!.paymentId != null) {
        _didReturnFromBrowser = true;
        _viewModel!.verifyPayment();
      }
      return;
    }
    if (!mounted) return;

    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      _didReturnFromBrowser = true;
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not open payment page.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: ListenableBuilder(
        listenable: _viewModel!,
        builder: (context, _) {
          return _PaymentStatus(
            viewModel: _viewModel!,
            onRetry: () {
              _viewModel?.dispose();
              _initViewModel();
              _startPayment();
            },
            onDone: () => context.go('/home'),
          );
        },
      ),
    );
  }
}

class _PaymentStatus extends StatelessWidget {
  final PaymentViewModel viewModel;
  final VoidCallback onRetry;
  final VoidCallback onDone;

  const _PaymentStatus({
    required this.viewModel,
    required this.onRetry,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: switch (viewModel.state) {
        PaymentState.initiating => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Preparing payment...'),
            ],
          ),
        ),
        PaymentState.awaitingVerification => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Verifying payment...'),
            ],
          ),
        ),
        PaymentState.verified => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Payment Successful!',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your booking is confirmed.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
        PaymentState.failed => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.cancel, size: 80, color: theme.colorScheme.error),
            const SizedBox(height: 24),
            Text(
              'Payment Failed',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
            if (viewModel.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                viewModel.errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
