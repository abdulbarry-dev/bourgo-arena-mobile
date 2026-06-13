import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/presentation/payment/payment_selection_view_model.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/repositories/payment_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/subscribe_to_plan_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/pay_with_loyalty_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/animated_loyalty_balance.dart';
import '../common/widgets/app_toast.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/celebration_overlay.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/confirm_action_modal.dart';
import 'package:bourgo_arena_mobile/presentation/payment/payment_webview_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';

class PaymentSelectionScreen extends StatefulWidget {
  final Plan plan;
  final String? childId;
  final Subscription? subscription;

  const PaymentSelectionScreen({
    super.key,
    required this.plan,
    this.childId,
    this.subscription,
  });

  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  late final PaymentSelectionViewModel _viewModel;
  bool _hasCelebrated = false;

  @override
  void initState() {
    super.initState();
    _viewModel = PaymentSelectionViewModel(
      paymentRepository: locator<PaymentRepository>(),
      subscribeToPlanUseCase: locator<SubscribeToPlanUseCase>(),
      payWithLoyaltyUseCase: locator<PayWithLoyaltyUseCase>(),
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
    if ((_viewModel.state == PaymentSelectionState.verified ||
            _viewModel.state == PaymentSelectionState.loyaltySuccess) &&
        !_hasCelebrated) {
      _hasCelebrated = true;
      CelebrationOverlay.show(context);
    }
    setState(() {}); // Rebuild on state change
  }

  Future<void> _startPayment(String provider) async {
    if (provider == 'loyalty') {
      final confirmed = await ConfirmActionModal.show(
        context: context,
        icon: Symbols.stars,
        title: AppLocalizations.of(context)!.paymentPayWithPointsTitle,
        message: AppLocalizations.of(
          context,
        )!.paymentPayWithPointsWarning(widget.plan.price.toStringAsFixed(2)),
        confirmLabel: AppLocalizations.of(context)!.paymentPayNow,
      );
      if (confirmed != true) return;
    }

    await _viewModel.subscribeAndPay(
      planId: widget.plan.id,
      amount: widget.plan.price,
      provider: provider,
      description: 'Subscription to ${widget.plan.name}',
      childId: widget.childId,
      subscription: widget.subscription,
    );

    if (_viewModel.state == PaymentSelectionState.loyaltySuccess) {
      return;
    }

    final url = _viewModel.paymentUrl;
    if (url == null || !mounted) return;

    if (kIsWeb) {
      final uri = Uri.tryParse(url);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, webOnlyWindowName: '_self');
      } else if (mounted) {
        AppToast.show(
          context,
          AppLocalizations.of(context)!.paymentErrorCannotOpen,
          type: AppToastType.error,
        );
      }
      return;
    }

    final result = await Navigator.of(context).push<PaymentWebViewResult>(
      MaterialPageRoute(
        builder: (context) => PaymentWebViewScreen(paymentUrl: url),
      ),
    );

    // Explicit gateway failure — no need to verify.
    if (result == PaymentWebViewResult.failure) {
      _viewModel.reset();
      if (mounted) {
        AppToast.show(
          context,
          AppLocalizations.of(context)!.paymentFailedRetry,
          type: AppToastType.error,
        );
      }
      return;
    }

    // For success redirects and manual dismissal, always verify —
    // the payment may have gone through before the user closed the screen.
    _viewModel.verifyPayment();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SubScreenAppBar(
        title: AppLocalizations.of(context)!.paymentMethodTitle,
        onBack: () {
          if (_viewModel.state == PaymentSelectionState.verified) {
            context.go('/home');
          } else {
            context.pop();
          }
        },
      ),
      body: _buildBody(theme, appColors),
    );
  }

  Widget _buildBody(ThemeData theme, AppColors appColors) {
    switch (_viewModel.state) {
      case PaymentSelectionState.subscribing:
        return _buildLoading(
          theme,
          AppLocalizations.of(context)!.paymentLoadingCreatingSub,
        );
      case PaymentSelectionState.initiating:
        return _buildLoading(
          theme,
          AppLocalizations.of(context)!.paymentLoadingPreparing,
        );
      case PaymentSelectionState.loyaltyPaying:
        return _buildLoading(
          theme,
          AppLocalizations.of(context)!.paymentLoadingLoyalty,
        );
      case PaymentSelectionState.awaitingVerification:
        return _buildLoading(
          theme,
          AppLocalizations.of(context)!.paymentLoadingVerifying,
        );
      case PaymentSelectionState.verified:
      case PaymentSelectionState.loyaltySuccess:
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
            AppLocalizations.of(context)!.paymentSuccessTitle,
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
            widget.childId != null
                ? AppLocalizations.of(
                    context,
                  )!.paymentSuccessChildDesc(widget.plan.name)
                : AppLocalizations.of(context)!.paymentSuccessDesc,
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
              foregroundColor: theme.colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 56),
            ),
            child: Text(
              AppLocalizations.of(context)!.paymentBackToHome,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
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
            _viewModel.errorMessage ??
                AppLocalizations.of(context)!.paymentUnknownError,
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
              )
              .animate()
              .fade(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
          const SizedBox(height: 24),
          Text(
                AppLocalizations.of(context)!.paymentTotalAmount,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
                textAlign: TextAlign.center,
              )
              .animate(delay: 50.ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
          const SizedBox(height: 8),
          Text(
                '${widget.plan.price.toStringAsFixed(0)} TND',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontFamily: AppConstants.displayFontFamily,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              )
              .animate(delay: 100.ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
          Text(
                AppLocalizations.of(context)!.paymentForPlan(widget.plan.name),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              )
              .animate(delay: 150.ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
          const SizedBox(height: 48),

          Text(
                AppLocalizations.of(context)!.paymentSelectMethod,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              )
              .animate(delay: 200.ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
          const SizedBox(height: 16),

          // Konnect Button
          _PaymentMethodCard(
                title: AppLocalizations.of(context)!.paymentMethodKonnectTitle,
                subtitle: AppLocalizations.of(
                  context,
                )!.paymentMethodKonnectSubtitle,
                icon: Symbols.credit_card,
                brandColor: theme.colorScheme.primary,
                theme: theme,
                appColors: appColors,
                onTap: () => _startPayment('konnect'),
              )
              .animate(delay: 250.ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
          const SizedBox(height: 32),

          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: appColors.bgBorder)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppLocalizations.of(context)!.paymentOr,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Expanded(child: Divider(color: appColors.bgBorder)),
            ],
          ).animate(delay: 300.ms).fade(duration: 400.ms),
          const SizedBox(height: 32),

          // Loyalty Balance Button
          _PaymentMethodCard(
                title: AppLocalizations.of(context)!.paymentMethodLoyaltyTitle,
                subtitle: AppLocalizations.of(
                  context,
                )!.paymentMethodLoyaltySubtitle,
                icon: Symbols.stars,
                brandColor: theme.colorScheme.primary,
                theme: theme,
                appColors: appColors,
                isPrimary: true,
                onTap: () {
                  _startPayment('loyalty');
                },
                bottomContent: const AnimatedLoyaltyBalance(isVisible: true),
              )
              .animate(delay: 350.ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
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
  final Widget? bottomContent;

  const _PaymentMethodCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.brandColor,
    required this.theme,
    required this.appColors,
    this.isPrimary = false,
    required this.onTap,
    this.bottomContent,
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
                        ?bottomContent,
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
