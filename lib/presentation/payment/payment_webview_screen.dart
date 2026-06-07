import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String successUrlPrefix;
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
  WebViewController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              if (mounted) setState(() => _isLoading = true);
            },
            onPageFinished: (String url) {
              if (mounted) setState(() => _isLoading = false);
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith(widget.successUrlPrefix)) {
                Navigator.of(context).pop(true);
                return NavigationDecision.prevent;
              } else if (request.url.startsWith(widget.failureUrlPrefix)) {
                Navigator.of(context).pop(false);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.paymentUrl));
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
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: Stack(
        children: [
          if (_controller != null) WebViewWidget(controller: _controller!),
          if (kIsWeb)
            const Center(
              child: Text(
                'Web payment opens in a new tab. Please close this window if it remains open.',
              ),
            ),
          if (_isLoading && !kIsWeb)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
