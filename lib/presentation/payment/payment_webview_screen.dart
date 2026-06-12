import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();

    if (!kIsWeb) {
      _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    }

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

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'SECURE PAYMENT',
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
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
