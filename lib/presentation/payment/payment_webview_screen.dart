import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';

/// Result returned when [PaymentWebViewScreen] closes.
enum PaymentWebViewResult {
  /// An explicit success redirect URL was received from the gateway.
  success,

  /// An explicit failure redirect URL was received from the gateway.
  failure,

  /// User dismissed the screen manually (back / X button) without
  /// completing or failing payment.
  dismissed,
}

/// In-app WebView that hosts the Konnect payment page.
///
/// Keeps all navigation inside the WebView so the gateway never opens
/// an external browser tab. Detects success / failure purely via URL
/// prefix matching on each navigation / page-load event.
class PaymentWebViewScreen extends StatefulWidget {
  /// The Konnect payment URL to load.
  final String paymentUrl;

  /// URL prefix that signals a successful payment redirect.
  final String successUrlPrefix;

  /// URL prefix that signals a failed payment redirect.
  final String failureUrlPrefix;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    this.successUrlPrefix = 'bourgo://payment/success',
    this.failureUrlPrefix = 'bourgo://payment/failure',
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  /// Guards against popping more than once.
  bool _hasPopped = false;

  /// Returns true if the current platform supports the official WebView.
  bool get _isWebViewSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  @override
  void initState() {
    super.initState();

    if (_isWebViewSupported) {
      _controller = WebViewController();
      _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      _controller
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              if (mounted) setState(() => _isLoading = true);
              _checkUrl(url);
            },
            onPageFinished: (url) {
              if (mounted) setState(() => _isLoading = false);
              _checkUrl(url);
            },
            onNavigationRequest: (request) {
              _checkUrl(request.url);
              // Always navigate in-frame — prevents target=_blank from
              // spawning an external browser tab.
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.paymentUrl));
    } else {
      _isLoading = false;
      // Automatically launch the URL on unsupported platforms.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _launchExternalGateway();
      });
    }
  }

  Future<void> _launchExternalGateway() async {
    final uri = Uri.tryParse(widget.paymentUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.paymentErrorCannotOpen),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  /// Checks [url] against the configured prefixes. First match wins;
  /// subsequent calls are no-ops thanks to the [_hasPopped] guard.
  void _checkUrl(String url) {
    if (_hasPopped || !mounted) return;
    if (url.startsWith(widget.successUrlPrefix)) {
      _pop(PaymentWebViewResult.success);
    } else if (url.startsWith(widget.failureUrlPrefix)) {
      _pop(PaymentWebViewResult.failure);
    }
  }

  void _pop(PaymentWebViewResult result) {
    if (_hasPopped || !mounted) return;
    _hasPopped = true;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          l10n.paymentSecurePaymentTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: appColors.bgSurface.withValues(alpha: 0.9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Symbols.close),
          onPressed: () => _pop(PaymentWebViewResult.dismissed),
        ),
      ),
      body: Stack(
        children: [
          if (_isWebViewSupported)
            WebViewWidget(controller: _controller)
          else
            _buildFallbackView(theme, appColors, l10n),
          if (_isLoading && _isWebViewSupported)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildFallbackView(
    ThemeData theme,
    AppColors appColors,
    AppLocalizations l10n,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: appColors.bgElevated,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                Symbols.open_in_new,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.paymentExternalTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.paymentExternalDesc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _launchExternalGateway,
              icon: const Icon(Symbols.open_in_new),
              label: Text(l10n.paymentOpenAgain),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _pop(PaymentWebViewResult.success),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(200, 50),
                side: BorderSide(color: theme.colorScheme.primary),
              ),
              child: Text(l10n.paymentDoneConfirm),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _pop(PaymentWebViewResult.dismissed),
              child: Text(l10n.paymentCancel),
            ),
          ],
        ),
      ),
    );
  }
}
