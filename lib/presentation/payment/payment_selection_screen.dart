import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/presentation/payment/payment_selection_view_model.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/repositories/payment_repository.dart';
import 'package:bourgo_arena_mobile/presentation/payment/payment_webview_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class PaymentSelectionScreen extends StatefulWidget {
  final Plan plan;

  const PaymentSelectionScreen({super.key, required this.plan});

  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  late final PaymentSelectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PaymentSelectionViewModel(
      paymentRepository: locator<PaymentRepository>(),
    );
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {}); // Rebuild on state change
  }

  Future<void> _startPayment(String provider) async {
    await _viewModel.initiatePayment(
      amount: widget.plan.price,
      provider: provider,
      description: 'Subscription to ${widget.plan.name}',
    );

    final url = _viewModel.paymentUrl;
    if (url == null || !mounted) return;

    if (kIsWeb) {
      final uri = Uri.tryParse(url);
      if (uri != null && await canLaunchUrl(uri)) {
        // On web, launch in the same tab so the redirect loads our app with /payment/success
        await launchUrl(uri, webOnlyWindowName: '_self');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open payment page.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      return;
    }

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => PaymentWebViewScreen(paymentUrl: url),
      ),
    );

    if (result == true) {
      _viewModel.verifyPayment();
    } else {
      _viewModel.reset();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Payment cancelled or failed.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'PAYMENT METHOD',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: appColors.bgSurface.withValues(alpha: 0.9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () {
            if (_viewModel.state == PaymentSelectionState.verified) {
              context.go('/home');
            } else {
              context.pop();
            }
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: appColors.bgBorder, height: 1.0),
        ),
      ),
      body: _buildBody(theme, appColors),
    );
  }

  Widget _buildBody(ThemeData theme, AppColors appColors) {
    switch (_viewModel.state) {
      case PaymentSelectionState.initiating:
        return _buildLoading(theme, 'Preparing payment...');
      case PaymentSelectionState.awaitingVerification:
        return _buildLoading(theme, 'Verifying payment...');
      case PaymentSelectionState.verified:
        return _buildSuccess(theme);
      case PaymentSelectionState.failed:
        return _buildFailed(theme);
      case PaymentSelectionState.idle:
        return _buildSelection(theme, appColors);
    }
  }

  Widget _buildLoading(ThemeData theme, String message) {
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

  Widget _buildSuccess(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Symbols.check_circle,
            size: 100,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            'PAYMENT SUCCESSFUL',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontFamily: AppConstants.displayFontFamily,
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your subscription to ${widget.plan.name} is now active.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text(
              'BACK TO HOME',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailed(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Symbols.error, size: 100, color: theme.colorScheme.error),
          const SizedBox(height: 32),
          Text(
            'PAYMENT FAILED',
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
            _viewModel.errorMessage ?? 'An unknown error occurred.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => _viewModel.reset(),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.onSurface,
              minimumSize: const Size(double.infinity, 56),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            child: const Text(
              'TRY AGAIN',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelection(ThemeData theme, AppColors appColors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Order Summary
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: appColors.bgElevated,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                Symbols.shopping_cart_checkout,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'TOTAL AMOUNT',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.plan.price.toStringAsFixed(0)} TND',
            style: theme.textTheme.displayMedium?.copyWith(
              fontFamily: AppConstants.displayFontFamily,
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'For ${widget.plan.name}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          Text(
            'SELECT PAYMENT METHOD',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Konnect Button
          _PaymentMethodCard(
            title: 'Pay with Konnect',
            subtitle: 'Bank Cards, E-Dinar, Wallets',
            icon: Symbols.credit_card,
            brandColor: const Color(0xFF005AE2), // Konnect Blue
            theme: theme,
            appColors: appColors,
            onTap: () => _startPayment('konnect'),
          ),
          const SizedBox(height: 32),

          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: appColors.bgBorder)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Expanded(child: Divider(color: appColors.bgBorder)),
            ],
          ),
          const SizedBox(height: 32),

          // Loyalty Balance Button
          _PaymentMethodCard(
            title: 'Pay with Loyalty Balance',
            subtitle: 'Use your accumulated points',
            icon: Symbols.stars,
            brandColor: theme.colorScheme.primary, // App Primary (Neon)
            theme: theme,
            appColors: appColors,
            isPrimary: true,
            onTap: () {
              // Usually handled internally via another endpoint, but for now we simulate
              _startPayment('loyalty');
            },
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color brandColor;
  final ThemeData theme;
  final AppColors appColors;
  final bool isPrimary;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.brandColor,
    required this.theme,
    required this.appColors,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPrimary
                ? brandColor.withValues(alpha: 0.5)
                : appColors.bgBorder,
            width: isPrimary ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Left brand color strip
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 6,
              child: Container(color: brandColor),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: brandColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: brandColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Symbols.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
