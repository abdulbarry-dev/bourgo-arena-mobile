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

  /// Creates a [PaymentGatewayScreen].
  const PaymentGatewayScreen({super.key, required this.reservationId});

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen>
    with WidgetsBindingObserver {
  String _selectedGateway = 'konnect';
  PaymentViewModel? _viewModel;
  bool _didReturnFromBrowser = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
      gateway: _selectedGateway,
    );
    setState(() {});
  }

  Future<void> _startPayment() async {
    _initViewModel();
    await _viewModel!.initiatePayment();

    final url = _viewModel!.paymentUrl;
    if (url == null || !mounted) return;

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
      body: _viewModel == null
          ? _GatewaySelector(
              selected: _selectedGateway,
              onChanged: (g) => setState(() => _selectedGateway = g),
              onPay: _startPayment,
            )
          : ListenableBuilder(
              listenable: _viewModel!,
              builder: (context, _) {
                return _PaymentStatus(
                  viewModel: _viewModel!,
                  onRetry: () => setState(() {
                    _viewModel?.dispose();
                    _viewModel = null;
                  }),
                  onDone: () => context.go('/home'),
                );
              },
            ),
    );
  }
}

class _GatewaySelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  final VoidCallback onPay;

  const _GatewaySelector({
    required this.selected,
    required this.onChanged,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Choose a payment method',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          _GatewayOption(
            label: 'Konnect',
            logo: Icons.payment,
            value: 'konnect',
            selected: selected,
            onTap: () => onChanged('konnect'),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onPay,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Proceed to Payment'),
          ),
        ],
      ),
    );
  }
}

class _GatewayOption extends StatelessWidget {
  final String label;
  final IconData logo;
  final String value;
  final String selected;
  final VoidCallback onTap;

  const _GatewayOption({
    required this.label,
    required this.logo,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = value == selected;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.05)
              : null,
        ),
        child: Row(
          children: [
            Icon(logo, size: 32, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Text(label, style: theme.textTheme.titleMedium),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: theme.colorScheme.primary),
          ],
        ),
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
