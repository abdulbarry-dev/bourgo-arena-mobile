import 'package:flutter/material.dart';
import '../../core/theme/bourgo_theme.dart';
import 'nfc_view_model.dart';
import '../../core/di/locator.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/nfc_service.dart';

class NfcScreen extends StatefulWidget {
  final NfcViewModel? viewModel;

  const NfcScreen({super.key, this.viewModel});

  @override
  State<NfcScreen> createState() => _NfcScreenState();
}

class _NfcScreenState extends State<NfcScreen> {
  late NfcViewModel _viewModel;

  List<String> _visibleFallbackMethods(List<String> methods) {
    return methods
        .where((method) => method.toLowerCase() != 'fingerprint')
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? locator<NfcViewModel>();
    // Fetch initial status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchNfcStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Digital NFC Card')),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading && _viewModel.physicalStatus == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.errorMessage != null && _viewModel.physicalStatus == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_viewModel.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _viewModel.fetchNfcStatus,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final digitalStatus = _viewModel.digitalStatus;
    if (digitalStatus != null && !digitalStatus.supported) {
      return _buildUnsupportedDeviceReport(digitalStatus.reasons);
    }

    final spacing = context.spacing;

    return SingleChildScrollView(
      padding: spacing.screenPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPhysicalCard(),
          SizedBox(height: spacing.xl),
          _buildDigitalCard(),
        ],
      ),
    );
  }

  Widget _buildUnsupportedDeviceReport(List<String> reasons) {
    final spacing = context.spacing;
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return Center(
      child: SingleChildScrollView(
        padding: spacing.screenPadding(context),
        child: Container(
          width: double.infinity,
          padding: spacing.all(spacing.lg),
          decoration: BoxDecoration(
            color: colors.bgElevated,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.bgBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.phonelink_erase_rounded,
                  color: theme.colorScheme.onErrorContainer,
                  size: 30,
                ),
              ),
              SizedBox(height: spacing.md),
              Text(
                'Digital NFC Is Not Supported',
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: spacing.xs),
              Text(
                'This smartphone cannot be configured as a digital NFC access key. You can continue using your physical NFC card and PIN access.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (reasons.isNotEmpty) ...[
                SizedBox(height: spacing.md),
                Text('Detected status', style: theme.textTheme.titleSmall),
                SizedBox(height: spacing.xs),
                for (final reason in reasons)
                  Padding(
                    padding: EdgeInsets.only(bottom: spacing.xs),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 16,
                          color: theme.colorScheme.error,
                        ),
                        SizedBox(width: spacing.xs),
                        Expanded(child: Text(reason.replaceAll('_', ' '))),
                      ],
                    ),
                  ),
              ],
              SizedBox(height: spacing.md),
              OutlinedButton.icon(
                onPressed: _viewModel.fetchNfcStatus,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Recheck Device Compatibility'),
              ),
              SizedBox(height: spacing.sm),
              TextButton.icon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhysicalCard() {
    final status = _viewModel.physicalStatus;
    if (status == null) return const SizedBox.shrink();

    final spacing = context.spacing;
    final colors = Theme.of(context).extension<AppColors>()!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: spacing.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.bgBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.credit_card, color: colorScheme.primary),
              SizedBox(width: spacing.sm),
              Text(
                AppLocalizations.of(context)!.profileAccessNfc,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          if (status.isReady) ...[
            Text('Status: Active', style: TextStyle(color: Colors.green)),
            if (status.cardUid != null) Text('Card UID: ${status.cardUid}'),
          ] else if (!status.hasCard) ...[
            const Text('You do not have a physical card assigned.'),
            SizedBox(height: spacing.md),
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Request Physical Card'),
                    content: const Text(
                      'Physical card requests are managed by staff. Please contact the front desk.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Request Physical Card'),
            ),
          ] else ...[
            Text('Status: ${status.cardStatus ?? 'Unknown'}'),
            if (status.fallbackMethods.isNotEmpty) ...[
              SizedBox(height: spacing.sm),
              const Text('Fallback methods:'),
              for (final method in status.fallbackMethods) Text('- $method'),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildDigitalCard() {
    final status = _viewModel.digitalStatus;
    if (status == null) return const SizedBox.shrink();

    final spacing = context.spacing;
    final colors = Theme.of(context).extension<AppColors>()!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: spacing.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.bgBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.smartphone, color: colorScheme.primary),
              SizedBox(width: spacing.sm),
              Text(
                'Digital NFC Access',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          if (!status.supported) ...[
            const Text(
              'Digital NFC access is not available on this device. Please use your physical card or PIN for entry.',
            ),
            if (status.reasons.isNotEmpty) ...[
              SizedBox(height: spacing.sm),
              const Text('Reasons:'),
              for (final r in status.reasons) Text('- $r'),
            ],
            if (_visibleFallbackMethods(status.fallbackMethods).isNotEmpty) ...[
              SizedBox(height: spacing.sm),
              const Text('Fallback methods:'),
              for (final method in _visibleFallbackMethods(
                status.fallbackMethods,
              ))
                Text('- $method'),
            ],
          ] else if (status.setupStatus == 'completed' || status.isReady) ...[
            Text('Status: Ready to use', style: TextStyle(color: Colors.green)),
            SizedBox(height: spacing.xs),
            const Text('Your phone is configured as your digital key.'),
            SizedBox(height: spacing.md),
            ElevatedButton(
              onPressed: () async {
                final started = await NfcService.startHceIfSupported();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      started
                          ? 'Local NFC service started.'
                          : 'Unable to start local NFC service on this device.',
                    ),
                  ),
                );
              },
              child: const Text('Start HCE Service'),
            ),
          ] else if (status.setupStatus == 'not_started' ||
              status.setupStatus == 'revoked') ...[
            const Text('Your device supports Digital NFC Access.'),
            SizedBox(height: spacing.md),
            ElevatedButton(
              onPressed: _viewModel.isLoading
                  ? null
                  : _viewModel.setupDigitalNfc,
              child: _viewModel.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Setup Digital Key'),
            ),
            if (_visibleFallbackMethods(status.fallbackMethods).isNotEmpty) ...[
              SizedBox(height: spacing.sm),
              const Text('Fallback methods:'),
              for (final f in _visibleFallbackMethods(status.fallbackMethods))
                Text('- $f'),
            ],
          ],
        ],
      ),
    );
  }
}
