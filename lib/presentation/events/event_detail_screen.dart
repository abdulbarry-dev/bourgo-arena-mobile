import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/celebration_overlay.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_error_state.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/confirm_action_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  final Event? event;

  const EventDetailScreen({super.key, required this.eventId, this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  Event? _event;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isActionLoading = false;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _event = widget.event;
      _isLoading = false;
    } else {
      _loadEvent();
    }
  }

  Future<void> _loadEvent() async {
    final useCase = locator<GetEventByIdUseCase>();
    final result = await useCase(widget.eventId);
    result.when(
      success: (event) => setState(() {
        _event = event;
        _isLoading = false;
      }),
      failure: (f) => setState(() {
        _errorMessage = f.message;
        _isLoading = false;
      }),
    );
  }

  Future<void> _register() async {
    if (_event == null || _isActionLoading) return;
    final theme = Theme.of(context);
    final confirmed = await ConfirmActionModal.show(
      context: context,
      icon: Symbols.emoji_events,
      title: "S'INSCRIRE",
      content: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _event!.name?.toUpperCase() ?? 'EVENT',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                fontFamily: AppConstants.displayFontFamily,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            _infoRow(theme, Symbols.calendar_month, _formatDateRange()),
            const SizedBox(height: 8),
            _infoRow(
              theme,
              Symbols.group,
              '${_event!.participantsCount ?? 0} / ${_event!.maxParticipants ?? 0} participants',
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    setState(() => _isActionLoading = true);
    final result = await locator<RegisterForEventUseCase>()(_event!.id);
    if (!mounted) return;
    setState(() => _isActionLoading = false);
    result.when(
      success: (reg) {
        if (reg.isWaitlisted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Added to waitlist.')));
        } else {
          CelebrationOverlay.show(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully registered!')),
          );
        }
      },
      failure: (f) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(f.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
    );
  }

  Future<void> _withdraw() async {
    if (_event == null || _isActionLoading) return;

    final confirmed = await ConfirmActionModal.show(
      context: context,
      icon: Symbols.cancel,
      title: 'RETIRER',
      message:
          'Voulez-vous vous retirer de ${_event!.name ?? 'cet événement'} ?',
      isDestructive: true,
    );

    if (confirmed != true) return;
    setState(() => _isActionLoading = true);
    final result = await locator<WithdrawFromEventUseCase>()(_event!.id);
    if (!mounted) return;
    setState(() => _isActionLoading = false);
    result.when(
      success: (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Withdrawn from event.')));
      },
      failure: (f) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(f.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
    );
  }

  Future<void> _checkIn() async {
    if (_event == null || _isActionLoading) return;
    setState(() => _isActionLoading = true);
    final result = await locator<CheckInToEventUseCase>()(_event!.id);
    if (!mounted) return;
    setState(() => _isActionLoading = false);
    result.when(
      success: (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Checked in!')));
      },
      failure: (f) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(f.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    if (_isLoading)
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    if (_errorMessage != null)
      return Scaffold(
        appBar: AppBar(),
        body: PremiumErrorState(
          title: 'ERROR',
          message: _errorMessage!,
          actionLabel: 'RETRY',
          onRetry: () {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
            _loadEvent();
          },
        ),
      );
    if (_event == null)
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Event not found')),
      );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
          color: theme.colorScheme.onSurface,
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: appColors.bgSurface.withValues(alpha: 0.9),
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildImageCarousel(theme),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildContent(theme, appColors),
                ),
              ),
            ],
          ),
          Positioned(left: 24, right: 24, bottom: 32, child: _buildCTA(theme)),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(ThemeData theme) {
    final images = _event!.images;
    if (images.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Symbols.emoji_events,
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
      );
    }
    return Stack(
      children: [
        PageView.builder(
          itemCount: images.length,
          onPageChanged: (i) => setState(() => _currentImageIndex = i),
          itemBuilder: (_, i) => Image.network(
            images[i],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: theme.colorScheme.surfaceContainerHighest),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentImageIndex == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentImageIndex == i
                        ? theme.colorScheme.primary
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          left: 16,
          bottom: 16,
          child: Row(
            children: [
              if (_event!.format != null)
                _chip(theme, _event!.format!, theme.colorScheme.primary),
              const SizedBox(width: 8),
              _chip(
                theme,
                (_event!.status ?? 'unknown').toUpperCase(),
                _statusColor(theme),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(ThemeData theme, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _statusColor(ThemeData theme) {
    switch (_event!.status) {
      case 'open':
        return theme.colorScheme.primary;
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return theme.colorScheme.onSurfaceVariant;
      case 'canceled':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  Widget _buildContent(ThemeData theme, AppColors appColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _event!.name?.toUpperCase() ?? 'EVENT',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontFamily: AppConstants.displayFontFamily,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        _infoRow(theme, Symbols.calendar_month, _formatDateRange()),
        if (_event!.registrationDeadline != null) ...[
          const SizedBox(height: 10),
          _infoRow(
            theme,
            Symbols.edit_calendar,
            'Register by ${_formatDate(_event!.registrationDeadline!)}',
          ),
        ],
        if (_event!.format != null) ...[
          const SizedBox(height: 10),
          _infoRow(theme, Symbols.sports_esports, '${_event!.format!} Format'),
        ],
        if (_event!.requiresCheckIn) ...[
          const SizedBox(height: 10),
          _infoRow(theme, Symbols.how_to_reg, 'Check-in required on event day'),
        ],
        const SizedBox(height: 20),
        _participantsProgress(theme),
        const SizedBox(height: 20),
        if (_event!.description != null && _event!.description!.isNotEmpty)
          Text(
            _event!.description!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _infoRow(ThemeData theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateRange() {
    final start = _event!.startDate;
    final end = _event!.endDate;
    if (start == null && end == null) return 'Date TBD';
    final s = start != null ? _formatDate(start) : 'TBD';
    final e = end != null ? _formatDate(end) : 'TBD';
    return s == e ? s : '$s – $e';
  }

  String _formatDate(String iso) {
    try {
      return DateFormat('MMM d, yyyy').format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }

  Widget _participantsProgress(ThemeData theme) {
    final count = _event!.participantsCount ?? 0;
    final max = _event!.maxParticipants ?? 0;
    final ratio = max > 0 ? count / max : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Symbols.group,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              '$count / $max participants',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '${(ratio * 100).round()}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(
              ratio >= 1 ? theme.colorScheme.error : theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCTA(ThemeData theme) {
    final isOpen = _event!.isRegistrationOpen;
    return ElevatedButton(
      onPressed: _isActionLoading ? null : (isOpen ? _register : null),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        disabledBackgroundColor: theme.colorScheme.primary.withValues(
          alpha: 0.4,
        ),
      ),
      child: _isActionLoading
          ? SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onPrimary,
              ),
            )
          : Text(
              isOpen ? 'REGISTER FOR EVENT' : 'REGISTRATION CLOSED',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
    );
  }
}
